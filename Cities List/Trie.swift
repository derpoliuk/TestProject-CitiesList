//
//  Trie.swift
//  Cities List
//
//  Created by Stanislav Derpoliuk on 12.07.2020.
//  Copyright © 2020 Stanislav Derpoliuk. All rights reserved.
//

import Foundation

/**
 A trie data structure containing words.

 Each node is a single character of a word.

 Taken from [Ray Wenderlich website](https://www.raywenderlich.com/892-swift-algorithm-club-swift-trie-data-structure) with slight modifications.
 */
final class Trie: NSObject, NSCoding {
    private enum Constants {
        static let wordsKey = "words"
    }
    typealias Node = TrieNode<Character>
    /// The number of words in the trie
    var count: Int {
        return wordCount
    }
    /// Is the trie empty?
    var isEmpty: Bool {
        return wordCount == 0
    }
    /// All words currently in the trie
    var words: [String] {
        return wordsInSubTrie(rootNode: root, partialWord: "")
    }
    fileprivate let root: Node
    fileprivate var wordCount: Int

    override init() {
        root = Node()
        wordCount = 0
        super.init()
    }

    // MARK: NSCoding
    required convenience init?(coder: NSCoder) {
        self.init()
        if let words = coder.decodeObject(forKey: Constants.wordsKey) as? [String] {
            words.forEach(insert)
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(words, forKey: Constants.wordsKey)
    }
}

extension Trie {
    /**
     Inserts a word into the trie. If the word is already present, do nothing.

     - Parameter word: The word to be inserted
     */
    func insert(word: String) {
        guard !word.isEmpty else {
            return
        }
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }
        // Is word already present?
        guard !currentNode.isTerminating else {
            return
        }
        wordCount += 1
        currentNode.isTerminating = true
    }

    /**
     Determines whether a word is in the trie

     - Parameter word: The word to check for
     - Returns: `true` if the word is present, `false` otherwise
     */
    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return false
            }
            currentNode = childNode
        }
        return currentNode.isTerminating
    }

    /**
     Attempts to walk to the last node of a word.

     The search will fail if the word is not present. This method doesn't check if the node is terminating

     - Parameter word: The word in question
     - Returns: The node where the search ended, `nil` if the search failed
     */
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }

    /**
     Attempts to walk to the terminating node of the word.

     The search will fail if the word is not present.

     - Parameter word: The word in question
     - Returns: The node where the search ended, `nil` of the search failed
     */
    private func findTerminalNodeOf(word: String) -> Node? {
        if let lastNode = findLastNodeOf(word: word) {
            return lastNode.isTerminating ? lastNode : nil
        }
        return nil
    }

    /**
     Deletes a word from the trie.

     Deletes a word from the trie by starting with the last letter and moving back, deleting nodes until either a non-leaf or a terminating node is found.

     - Parameter terminalNode: The node representing the last node of a word
     */
    private func deleteNodesForWordEndingWith(terminalNode: Node) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parentNode {
            lastNode = parentNode
            lastNode.children[character!] = nil
            character = lastNode.value
            if lastNode.isTerminating {
                break
            }
        }
    }

    /**
     Removes a word form the trie.

     If the word is not present or it is empty, do nothing. If the last node is a leaf, delete that node and higher nodes that are leaves until a terminating node or non-leaf is found. If the last node of the word has more children, the word is part of other words, mark the last node as non-terminating.

     - Parameter word: The word to be removed
     */
    func remove(word: String) {
        guard !word.isEmpty else {
            return
        }
        guard let terminalNode = findTerminalNodeOf(word: word) else {
            return
        }
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        } else {
            terminalNode.isTerminating = false
        }
        wordCount -= 1
    }

    /**
     Returns an array of words in a subtrie of the trie

     - Parameters:
        - rootNode: The root node of the subtrie
        - partialWord: The letters collected by traversing to this node
     - Returns: The words in the subtrie
     */
    fileprivate func wordsInSubTrie(rootNode: Node, partialWord: String) -> [String] {
        var subTrieWords: [String] = []
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isTerminating {
            subTrieWords.append(previousLetters)
        }
        for childNode in rootNode.children.values {
            let childWords = wordsInSubTrie(rootNode: childNode, partialWord: previousLetters)
            subTrieWords += childWords
        }
        return subTrieWords
    }

    /**
     Returns an array of words in a subtrie of the Trie that start with give prefix

     - Parameter prefix: The letters for word prefix
     - Returns: The words in the subtrie
     */
    func findWordsWithPrefix(prefix: String) -> [String] {
        var words: [String] = []
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isTerminating {
                words.append(prefixLowerCased)
            }
            for childNode in lastNode.children.values {
                let childWords = wordsInSubTrie(rootNode: childNode, partialWord: prefixLowerCased)
                words += childWords
            }
        }
        return words
    }
}

/**
 A node in the trie
 */
final class TrieNode<T: Hashable> {
    var value: T?
    weak var parentNode: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    var isLeaf: Bool {
        return children.isEmpty
    }

    /**
     Initializes a node.

     - Parameters:
        - value: The value that goes into the node
        - parentNode: A reference to this node's parent
     */
    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }

    /**
     Adds a child node to self. If the child is already present, do nothing.

     - Parameter value: The item to be added to this node
     */
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}
