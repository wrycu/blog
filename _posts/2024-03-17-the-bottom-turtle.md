---
layout: post
author: tim
tags: [infosec]
---

Password managers are fantastic: they allow very strong, unique passwords to be generated, (sometimes) stored, and used without taxing the very limited memory of a user - among many other benefits [^1].
![I wish I got this excited about password managers](../assets/images/turtle/excite.gif)

**Figure 1: Me thinking about how cool password managers are**

This amazing (but single point of failure) approach _should_ lead to the following question:

> How can I safely recover from losing access to my password manager?  

Today's post will be discussing possible answers to this question, with a focus on the trade-offs for various choices. I use 1Password, so some of the specifics are unique to that, but the overall discussion is solution-agnostic.

# A Quick Primer
This topic is somewhat technical. I'm including certain definitions of terms up-front to make sure we're all on the same page. Feel free to skip this section if you're familiar with the concepts already.
![Longer than expected](../assets/images/turtle/paint_dry.png)

**Figure 2: Well, that didn't take long, did it?**

- Password Manager
    - A piece of software used to generate and store passwords for many services
- 2FA
    - Stands for `Two Factor Authentication`. A means of proving an identity using two of the following three possible factors:
        - Something you know (a password)
        - Something you have (time-based code [e.g. `123456`], hardware token [e.g. Yubikey])
        - Something you are (fingerprint, retinal pattern)

# Recovering From The Loss of a Password Manager

> The following anecdote is told of William James. [...] After a lecture on cosmology and the structure of the solar system, James was accosted by a little old lady.
> 
> "Your theory that the sun is the centre of the solar system, and the earth is a ball which rotates around it has a very convincing ring to it, Mr. James, but it's wrong. I've got a better theory," said the little old lady.
> 
> "And what is that, madam?" inquired James politely.
> 
> "That we live on a crust of earth which is on the back of a giant turtle."
> 
> Not wishing to demolish this absurd little theory by bringing to bear the masses of scientific evidence he had at his command, James decided to gently dissuade his opponent by making her see some of the inadequacies of her position.
> 
> "If your theory is correct, madam," he asked, "what does this turtle stand on?"
> 
> "You're a very clever man, Mr. James, and that's a very good question," replied the little old lady, "but I have an answer to it. And it's this: The first turtle stands on the back of a second, far larger, turtle, who stands directly under him."
> 
> "But what does this second turtle stand on?" persisted James patiently.
> 
> To this, the little old lady crowed triumphantly,
>
> "It's no use, Mr. James—it's turtles all the way down."
>
> [Wikipedia](https://en.wikipedia.org/wiki/Turtles_all_the_way_down)

Figuring out how to recover from the loss of access to a password manager can seem a lot like trying to find the bottom turtle - you must place a "backdoor" of sorts to allow recovery if something goes wrong (thanks, JEREMY), but then you must secure that backdoor (lest it be used to bypass all of your fancy security.) Then you need a backdoor for _that_ access, and you need to secure that. And on the cycle goes.  To solve for this "most backiest back door" while avoiding circular dependencies - wherein your ability to recover something is dependent upon access to the thing being recovered - it's important to think through how access to your password manager can fail and what you can do to recover from such a failure. Since there must be a "bottom turtle" somewhere, I'll also discuss what can be done to secure that little bundle of joy.

![Finding the Bottom Turtle](../assets/images/turtle/turtles.jpg)

**Figure 3: The turtles themselves must know where the bottom turtle is, right?**

The table below explores the failure cases I've thought through. It handles both password only (1FA) and the more secure mode, 2FA. Note that the recovery options are unique to my password manager, but the section below is not.

| Failure Case                                                | Scenario                                 | Recovery Options (1FA)                                           | Recovery Options (2FA)                                                                                                             |
| ----------------------------------------------------------- |------------------------------------------| ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Lose access to password                                     | Forget password                          | [Use recovery kit](https://support.1password.com/emergency-kit/) | 1. [Use recovery kit](https://support.1password.com/emergency-kit/)<br>2. [Recovery flow](https://support.1password.com/recovery/) |
| Lose access to all authenticated sessions                   | Power surge while devices are plugged in | [Use recovery kit](https://support.1password.com/emergency-kit/) | 1. [Use recovery kit](https://support.1password.com/emergency-kit/)<br>2. [Recovery flow](https://support.1password.com/recovery/) |
| Lose access to second factor                                | Lose your phone                          | N/A                                                              | 1. Use alternate, pre-registered second factor<br>2. Use authenticated session to disable (and re-enable) 2FA                      |
| Lose access to password and all authenticated sessions      | Forget password and power surge          | [Use recovery kit](https://support.1password.com/emergency-kit/) | [Recovery flow](https://support.1password.com/recovery/)                                                                           |
| Lose access to second factor and all authenticated sessions | Power surge while devices are plugged in | N/A                                                              | [Recovery flow](https://support.1password.com/recovery/)                                                                           |
| Lose access to 2 factors and all authenticated sessions     | Earthquake, tornado, etc                 | N/A                                                              | [Recovery flow](https://support.1password.com/recovery/)                                                                           |
| Permanently lose access to password manager                 | 1Password abruptly goes out of business  | Use 2FA recovery code DB                                         | Use 2FA recovery code DB                                                                                                           |

So, for me, recovery requires either a recovery kit or a recovery flow.
## Securing Your Recovery Kit
For 1Password, the recovery kit consists of your master password and secret key both written down on (or typed into) a document. This provides the ability to recover either of these values if access to them is lost (see the table above for how that might happen.) If you use another password manager, consider these questions for whatever recovery method it provides.

So, how do we want to secure this? I've put together a list of ways to secure it, along with the pros and cons of each.

### Write It Down
You could write this information down on a post-it note and stick it to your monitor. This has the benefits of being free and easily accessible, while having the downside of being easily accessible and granting full access to your password manager to anyone who steals it. It's also prone to destruction.

### Share It With A Friend
You could take that post-it note and give it to a friend. This is (probably) still free, and essentially protects against a target-of-opportunity type attack, since the backup medium is not stored by the person who owns it. You are, of course, trusting your friend not to totally own your password manager... and it's still prone to destruction.

![Yes!](../assets/images/turtle/trust.gif)
**Figure 4: Your friend when you ask them if they want to store your post-it note**

### Safe
You could literally print the info on a piece of paper and chuck it in a safe in your closet... or wherever people keep safes. I wouldn't know; I've never owned or operated one. This has the benefit that it's easy to access and doesn't rely on much. It has the downsides that now you have to remember a combination, it's prone to destruction, and (if anyone can break into your safe) it enables full access to your password manager.
### Safe Deposit Box
You could instead decide that your closet is already full enough and go to a bank and rent a safe deposit box. This has the same benefits of a safe (since it essentially is one) while, in theory, limiting the likelihood of destruction or break in and removing the need to remember a combo.  It retains the downsides of being slightly prone to destruction and possession of a single, physical object[^2] being enough to bypass all protections, while adding the additional downside of a monthly fee.
### Encrypt It
You could eschew _ancient_ physical solutions and instead shove your secrets into some form of encrypted container. This essentially eliminates chances of physical destruction, but it retains the downsides that a single (now digital) object is sufficient to bypass your security. It also introduces the need to retain yet another password (and one which is rarely used, at that.)

![I can remember things](../assets/images/turtle/nervous.gif)

**Figure 5: Me trying to remember any password I haven't used in like... a week**

### Encrypt It & Use a Safe Deposit Box
Being a big-brained person, you could combine the previous two options by storing the password in a safe deposit box. This removes the ability for someone compromising one location to bypass all of your security, as access to the container is unhelpful without also having access to the password, and the attack vectors to obtain both portions have wildly different requires (physically being located somewhere vs compromising a specific computer.)  So, it has the benefit of being a relatively secure solution, though it still costs a monthly fee and is slightly prone to destruction.
### Use Passcrow
[Passcrow](https://passcrow.org) is a newly-developed way to perform password recovery involving [some fancy stuff](https://github.com/mailpile/python-passcrow/blob/main/docs/PROTOCOL.md) beyond the scope of this post. In summary, you encrypt your kit and send _pieces_ of the keys used to encrypt it to community-run servers, associating a piece of your identity with each community server. When you want to recover your kit, the community servers validate your identity (by sending an SMS message or email.) Verifying these means your backup can be decrypted without anyone retaining the ability to decrypt it. This has some sweet security benefits - you don't need to remember much of anything, it's not prone to destruction, and it costs nothing. On the flip side, it means anyone who can receive SMS and email as you (and who has access to your encrypted file) can recover your secrets and bypass your security. It also requires those community-run servers to be available when you need them.
### Encrypt It... With Style
Lastly, you can use Shamir Secret Sharing. This involves generating some number of encryption keys (M) and encrypting your kit[^3] in a way that a different number (N) of them may be used to decrypt it. For example, you could generate 5 keys when you encrypt your data, giving one each to your family and friends. You can then require that any three of those keys be used together to decrypt the kit. This has the benefit that you aren't reliant on any one person or location - in fact, you can scale it to any number, and even give the same person multiple keys to define a degree of "trustworthiness" (e.g. your significant other gets two keys, and you give two out to friends but require three to decrypt.) This, in theory, makes it very difficult for an attacker to capture those pieces, and makes them very resistant to destruction. It does, however, require that people retain these keys for an extended period... and that you remember who has them.

![High-class](../assets/images/turtle/sss.gif)

**Figure 6: Shamir Secret Sharing if it were a person**

## 1Password: Recovery Flow
For recovery options above, I mentioned a recovery flow. This is unique to 1Password and is quite handy. The flow is a nice feature for family accounts. It must be preconfigured, but it allows a family member to initiate a master password and secret key reset. This request generates an email sent to the person who lost their password, which they must then click and set up. Finally, the original family member must approve the reset request. This handshake process makes it difficult to abuse, and I don't have any complaints with it... except to note that this means your recovery kit must also now include the ability to regain access to your email address. If you're like me, your email password is also... you guessed it, in your password manager. You may want to include this in your super-dooper secret bundle.

---
{: data-content="footnotes"}

[^1]: No need to memorize passwords! Less likely to fall for phishing sites. You can share passwords. It's faster than typing. They tend to push toward better security with built-in tools. They can audit for known site breaches, and keep SSH keys encrypted.
[^2]: Probably actually two objects - a secondary 2fa token. But you get the idea...
[^3]: Well, probably not your _kit_. Probably a private key which can be used to decrypt the kit; retaining a public key to append to it
