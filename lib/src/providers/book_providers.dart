import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/book.dart';
import '../models/member.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';

final booksProvider = StreamProvider.family<List<Book>, String>((ref, shelfId) {
  if (shelfId.isEmpty) {
    return Stream<List<Book>>.empty();
  }
  debugPrint('📖 Watching books for shelf: $shelfId');
  return ref.watch(firestoreServiceProvider).watchBooks(shelfId).map((books) {
    debugPrint('📖 Received ${books.length} books from Firestore');
    return books;
  });
});

final bookDetailProvider = StreamProvider.autoDispose.family<Book?, (String shelfId, String bookId)>((ref, key) {
  final (shelfId, bookId) = key;
  if (shelfId.isEmpty || bookId.isEmpty) {
    return const Stream<Book?>.empty();
  }
  return ref.watch(firestoreServiceProvider).watchBook(shelfId: shelfId, bookId: bookId);
});

final selectedBookIdProvider = StateProvider<String?>((ref) => null);

final bookControllerProvider = StateNotifierProvider.family<BookController, AsyncValue<Book?>, String>((ref, shelfId) {
  return BookController(ref.watch(firestoreServiceProvider), shelfId, ref);
});

class BookController extends StateNotifier<AsyncValue<Book?>> {
  BookController(this._service, this._shelfId, this._ref) : super(const AsyncData(null));

  final FirestoreService _service;
  final String _shelfId;
  final Ref _ref;

  Future<Book?> createBook({required String title, String? description, required String ownerUid, required String currency}) async {
    final book = Book(
      id: '',
      shelfId: _shelfId,
      title: title,
      description: description,
      currency: currency,
      ownerUid: ownerUid,
      createdAt: DateTime.now(),
      members: [ShelfMember(uid: ownerUid, role: MemberRole.owner)],
      memberUids: [ownerUid],
    );
    state = const AsyncLoading();
    try {
      debugPrint('📖 Creating book: $title in shelf: $_shelfId');
      final createdBook = await _service.createBook(book);
      debugPrint('✅ Book created successfully: ${createdBook.id}');
      state = AsyncData(createdBook);
      // Invalidate books provider to force refresh
      _ref.invalidate(booksProvider(_shelfId));
      return createdBook;
    } catch (e, st) {
      debugPrint('❌ Error creating book: $e');
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<bool> updateBook(Book book) async {
    state = const AsyncLoading();
    try {
      await _service.updateBook(book);
      state = AsyncData(book);
      _ref.invalidate(booksProvider(_shelfId));
      return true;
    } catch (e, st) {
      debugPrint('❌ Error updating book: $e');
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> deleteBook(String bookId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteBook(shelfId: _shelfId, bookId: bookId);
      state = const AsyncData(null);
      _ref.invalidate(booksProvider(_shelfId));
      return true;
    } catch (e, st) {
      debugPrint('❌ Error deleting book: $e');
      state = AsyncError(e, st);
      return false;
    }
  }
}
