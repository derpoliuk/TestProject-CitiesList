//
//  TrieTests.swift
//  TrieTests
//
//  Created by Rick Zaccone on 2016-12-12.
//  Copyright © 2016 Rick Zaccone. All rights reserved.
//

import XCTest
@testable import Cities_List

/**
 TrieTests taken from https://github.com/raywenderlich/swift-algorithm-club/tree/master/Trie to make sure that my changes in Trie.swift won't break anything
 */
final class TrieTests: XCTestCase {
    private var trie = Trie()

    /// Tests that a newly created trie has zero words.
    func testCreate() {
        let trie = Trie()
        XCTAssertEqual(trie.count, 0)
    }

    /// Tests the insert method
    func testInsert() {
        let trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cutie")
        trie.insert(word: "fred")
        XCTAssertTrue(trie.contains(word: "cute"))
        XCTAssertFalse(trie.contains(word: "cut"))
        trie.insert(word: "cut")
        XCTAssertTrue(trie.contains(word: "cut"))
        XCTAssertEqual(trie.count, 4)
    }

    /// Tests the remove method
    func testRemove() {
        let trie = Trie()
        trie.insert(word: "cute")
        trie.insert(word: "cut")
        XCTAssertEqual(trie.count, 2)
        trie.remove(word: "cute")
        XCTAssertTrue(trie.contains(word: "cut"))
        XCTAssertFalse(trie.contains(word: "cute"))
        XCTAssertEqual(trie.count, 1)
    }

    /// Tests the words property
    func testWords() {
        let trie = Trie()
        var words = trie.words
        XCTAssertEqual(words.count, 0)
        trie.insert(word: "foobar")
        words = trie.words
        XCTAssertEqual(words[0], "foobar")
        XCTAssertEqual(words.count, 1)
    }

    /// Tests the archiving and unarchiving of the trie.
    func testArchiveAndUnarchive() {
        let resourcePath = Bundle.main.resourcePath! as NSString
        let fileName = "dictionary-archive"
        let filePath = resourcePath.appendingPathComponent(fileName)
        NSKeyedArchiver.archiveRootObject(trie, toFile: filePath)
        let trieCopy = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Trie
        XCTAssertEqual(trieCopy?.count, trie.count)
    }

    func testFindWordsWithPrefix() {
        let trie = Trie()
        trie.insert(word: "test")
        trie.insert(word: "another")
        trie.insert(word: "exam")
        let wordsAll = trie.findWordsWithPrefix(prefix: "")
        XCTAssertEqual(wordsAll.sorted(), ["another", "exam", "test"])
        let words = trie.findWordsWithPrefix(prefix: "ex")
        XCTAssertEqual(words, ["exam"])
        trie.insert(word: "examination")
        let words2 = trie.findWordsWithPrefix(prefix: "exam")
        XCTAssertEqual(words2, ["exam", "examination"])
        let noWords = trie.findWordsWithPrefix(prefix: "tee")
        XCTAssertEqual(noWords, [])
        let unicodeWord = "😬😎"
        trie.insert(word: unicodeWord)
        let wordsUnicode = trie.findWordsWithPrefix(prefix: "😬")
        XCTAssertEqual(wordsUnicode, [unicodeWord])
        trie.insert(word: "Team")
        let wordsUpperCase = trie.findWordsWithPrefix(prefix: "Te")
        XCTAssertEqual(wordsUpperCase.sorted(), ["team", "test"])
    }
}
