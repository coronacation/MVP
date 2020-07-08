# User Blocking


## App Store Review Guidelines - Apple

> ### 1.2 User Generated Content
> Apps with user-generated content present particular challenges, ranging from intellectual property infringement to anonymous bullying. To prevent abuse, apps with user-generated content or social networking services must include:
> * A method for filtering objectionable material from being posted to the app
> * A mechanism to report offensive content and timely responses to concerns
> * The ability to block abusive users from the service
> * Published contact information so users can easily reach you
> 
> Apps with user-generated content or services that end up being used primarily for pornographic content, Chatroulette-style experiences, objectification of real people (e.g. “hot-or-not” voting), making physical threats, or bullying do not belong on the App Store and may be removed without notice. If your app includes user-generated content from a web-based service, it may display incidental mature “NSFW” content, provided that the content is hidden by default and only displayed when the user turns it on via your website.

## Model: Twitter

Twitter has a user blocking feature that publicly well known and can serve as a model for mobile apps.

Granted, not every mobile app will have the same features as Twitter, but their system is respected and reliable. The result is a good user experience, and users remain loyal to the platform. 

https://help.twitter.com/en/using-twitter/blocking-and-unblocking-accounts

## Self-Policing

For most apps that are just starting out, it is not feasible to have a full-time moderator. When the community reaches maturity, volunteer moderators could be appointed. If an app has incoming revenue, someone could be hired to serve in this role.

For this app, the community will play a necessary role in moderating content.

### Rule 1

If a user receives 3 blocks, each from a unique user, they are permanently banned from using the app.

### Rule 2

If a user receives 5 reportings, each from a unique user, about any of their offers, they are permanently banned from using the app.

## Report Categories




## Questions to ask about App Promises

1. How do you prevent further harassment? How do you prevent a blocked user from further interacting with the person that blocked them?
2. What consequences can the app impose on the harasser?
3. What is the threshold for the harasser to face those consequences?

## App Consequences

### Ideas in order of severity


1. Disable ability to start new chat conversations
2. Delete an offending offering
3. Disable ability to post new offerings
4. Permanent ban from the app and data deletion

Other ideas

* Time out. This feels like a frustrating UX, and it's rarely seen as a feature in apps. Might as well just ban them.


## Scenario 1: A blocks B via chat

### Story

1. B sends an offensive message to A via chat.
2. A chooses to block B.


### App Promises

1. The chat conversation is disabled. Neither user can send new messages to each other.
2. User A can choose to delete the chat conversation they had with B, if they wish. It is critical that deletion be a distinct action from blocking, because it is plausible user A may wish to take screenshots of the offending parts of the conversation before deleting.
3. If User A has offers in the home feed, these offers will be hidden from User B to prevent new incoming messages.
4. User A is notified that someone has blocked them. See below for escalation messages.

## Scenario 2: B receives 3 blocks

### Story

1. A blocks B
2. C blocks B
3. D blocks B

### Escalation Messages to Blocked User

1. In the first offense, B will receive a gentle notification for the first blocking. They will be advised to read the community guidelines and that our policy is 3 blocks and you're permanently banned.
2. B will receive a stern warning that if they are blocked by just 1 more user, they will permanently  lose access to the app. Define what it means to be banned.
3. B will receive a final warning. They will be informed that they have been permanently banned from the app and will be signed out of the app.

App Promises during a Ban

1. Banned user will not be able to sign in with the account they registered. This is permanent, and cannot be undone.
2. Banned user's offers will be deleted from the database.
3. Banned user's chat messages will be deleted from the database.

## Scenario 3: User A reports B via Home feed

### Story

1. B posts an offer that is deemed offensive to A
2. A reports B and 

### Reporting Categories

- Offensive
- Inappropriate


## Shortcomings

### Repeated Harassment

If User B has been permanently banned, it is plausible that they can create a new account under a different name and then begin their harassment again.

While this is a sad reality for most social apps, it is difficult to craft a sustainable solution without more expertise. The game of cat and mouse could be played until the end of time.

Even Twitter [can't stop offending users from creating new accounts](https://help.twitter.com/en/safety-and-security/report-abusive-behavior):

> Why can’t Twitter block an account from making new accounts?
> 
> IP blocking is generally ineffective at stopping unwanted behavior, and may falsely prevent legitimate accounts from accessing our service.

The system proposed here is a decent start.

If the offending user begins their harassment again, they would be subject to the exact same rules that banned them in the first place. We as the app creators would have to place trust in the app's community see that the offending user is banned once again.

### Un-Blocking

While this is an important feature, it is not necessary for an MVP.

To prevent accidental blocking, a confirmation button can be presented to the user to ensure they meant to block a user.

