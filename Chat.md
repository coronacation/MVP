# About Chat

## Technology Stack

* Swift
* Cloud Firestore
* [MessageKit](https://cocoapods.org/pods/MessageKit) for UI presentation of chat elements such as message bubbles and chat textfield
* [SDWebImage](https://cocoapods.org/pods/SDWebImage) for asynchronous image downloading. Useful for getting chat avatar images.

## Quirks of this App

* DMs only. Direct Messages between one user and another.
* No Group messages.
* Based around the offer. If 2 users are chatting about one offer, it is possible to create a new chat conversation regarding a different offer.

## 2 View Controllers

1. List View Controller - shows a list of all conversations available.
2. Detail View Controller - shows the messages of a single conversation

## 2 Firestore Collections

Each collection is built specifically for a view controller.

1. Chats -> List VC
2. Threads -> Detail VC

```
Collections
	|--Chats
		|--doc: userID
			|--collection: chats
				|--doc: threadID
					|--askerFirstName
					|--askerLastName
					|--askerUID
					|--lastMsg
					|--lastMsgTimestamp
					|--postID
					|--postOwnerFirstName
					|--postOwnerLastName
					|--postOwnerUID
					|--postTitle
					|--threadID
	|--Threads
		|--doc: threadID
			|--askerUID
			|--postID
			|--postOwnerUID
			|--collection: messages
				|--doc: messageID
					|--content (aka message text)
					|--created (Timestamp)
					|--senderID
	|--Users
		|--doc: docID (not the same as userUID)
			|--email
			|--firstName
			|--lastName
			|--uid (aka userUID)
```

## Resources

Chaudhry's blog for a Detail VC
https://medium.com/@ibjects/simple-text-chat-app-using-firebase-in-swift-5-b9fa91730b6c

Chaudhry's Github Gists
https://gist.github.com/thechaudharysab/36b4802047b5c504033792fd75dcc9fd#file-chat-swift

Denormalization means it's ok to duplicate data in your database
https://www.youtube.com/watch?v=vKqXSZLLnHA