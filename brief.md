# Backend Engineer – Growth | Challenge

:wave:  Hi there!

To get a better understanding of your work and thinking process, we’ve put together a coding problem we’d like you to solve. It's meant to help us make informed and fair hiring decisions. Feel free to reach out to us (anatoli@blinkist.com :email:) if you have any questions.

We’d love to see your code and get insights into:

* how you approach such a task in general
* on what criteria you base your decisions
* how you architect such projects

Please make sure to cover technical insights as well as process and product considerations.

## Description

Bamboo team at Blinkist maintains a lot of mission-critical data integrations.
One of them is attribution analytics – a very important system that tells us where our users are coming from: marketing campaign, landing page, podcast, Youtube video, etc.
This data allows us to make informed marketing decisions and grow sustainably.

:point_right: **Your challenge today will be to build an MVP of an attribution analytics microservice.**

## Attribution Analytics 101

For the purpose of our exercise, let’s focus only on the web platform. Your microservice will receive 2 types of webhooks: pageviews and events.

Pageview webhooks are fired every time someone visits our website.
Event webhooks are fired when visitors make important actions like signing up, starting a trial, etc.
For our MVP, we’re only interested in the signup events.

To attribute a signup means to determine how this user got into Blinkist: was it a Google search?
A click on our paid ad?
Which campaign was it?
The goal is to record every possible data point so we (as a company) can answer questions like:

* Are we growing profitably?
* How is a certain marketing campaign doing?
* What web landing page drives the most signups?
* What’s the percentage of paid signups vs organic

## Tech details

Once deployed, your microservice will receive every single pageview that happens on Blinkist websites.
For every created Blinkist account your microservice will receive an event webhook.

Example payloads of pageview and event webhooks could be found in the [events.md](#file-events-md) and [pageviews.md](#file-pageviews-md) files.

## Acceptance criteria

Your microservice should be built with a REST MVC framework (preferably, Ruby on Rails) and have the following endpoints:

1. Receive pageview webhooks.
2. Receive signup event webhooks.
3. Expose signup attribution details for a user.
We leave the design of this endpoint to you, but focus on exposing as much information about attribution as possible.
This endpoint is consumed in real-time by other microservices for reporting conversion events, calculating ROI of campaigns,
make campaign bidding decisions, etc.

Share your solution with us in any way you like: Github repo, email us an archive, etc.

We hope you'll enjoy the challenge. Thanks for your time and good luck! :rocket:

The Bamboo Team @ Blinkist

---

# Pageview Webhook

## Payload

| Field | Description |
| --- | --- |
| fingerprint | An identifier of a web visitor (not necessarily with Blinkist account). Stored in a cookie. |
| user_id | An identifier of a Blinkist account. Stored in our production database. |
| url | What page a web visitor was on. |
| referrer_url | A URL of the previous page. |
| created_at | A pageview timestamp. |

## Examples

### Direct visit

```
{
  fingerprint: "b998efcb-1af3-4149-9b56-34c4482f6606",
  user_id: null,
  url: "https://www.blinkist.com/en",
  referrer_url: null,
  created_at: "2023-01-20 13:59:56.437947 UTC"
}
```

### Google Search

```
{
  fingerprint: "b998efcb-1af3-4149-9b56-34c4482f6606",
  user_id: null,
  url: "https://www.blinkist.com/en/books/lives-of-the-stoics-en",
  referrer_url: "https://www.google.de/",
  created_at: "2023-01-20 13:59:56.437947 UTC"
}
```

### Facebook Ad

```
{
  fingerprint: "b998efcb-1af3-4149-9b56-34c4482f6606",
  user_id: null,
  url: "https://www.blinkist.com/en/landing-pages/meet-blinkist?utm_source=facebook&utm_campaign=202301_US_NY_Resolutions&utm_medium=paid&utm_content=19284192381935",
  referrer_url: "https://www.facebook.com/",
  created_at: "2023-01-20 14:02:21.16808 UTC"
}
```

### A visitor with Blinkist account

```
{
  fingerprint: "b998efcb-1af3-4149-9b56-34c4482f6606",
  user_id: "6666bd053866341d6ad30000",
  url: "https://www.blinkist.com/en/library",
  referrer_url: null,
  created_at: "2023-01-18 12:33:41.127641 UTC"
}
```
