# RxDelivery
A demo of a simple prescription delivery service

Setup

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Questions
  * What was the hardest part of the implementation?
    - Deciding between scope and timeline. There were some things I should've either shortened up the implementation of, or just straight up cut in the interest of time. I probably should've just removed the links to edit locations that weren't your own, and left the ability to do it on the back-end intact in the interest of just getting it completed sooner. I ultimately decided not to scope. Other choices I'm fine with though. I decided to not default location to the current logged-in pharmacy.
  * What would be your next task if you had more time?
    - I would want to see the new Order functionality just default to using the logged in Pharmacy, and restrict editing to not allow editing of the location/pharmacy associated with the order. This would be followed by only showing orders associated with the current Pharmacy user. As part of testing those I'd probably make `RxDelivery.Fixtures` more simplistic. 
  * How could this project be more interesting?
    - Depending on desired outcome there are a couple things that could be changed.
    - Potential Desired Outcomes:
      + __Faster response from candidate:__
        * Scope it down. Make it a dumb "manual tracking" app. "Pharmacists want a contact list of their Patients, and not have other people be able to see their Patient's info" or something similarly small.
      + __Test of their abilities (general):__
        * Similar to "scope it down", but pick something fairly tricky, but not necessarily lengthy to implement. 
      + __Test of their abilities (elixir):__
        * Have them do something asynchronous, e.g. supervised long-lived processes that memoize their state under some condition, and can re-hydrate if re-spawned.
          - Follow-up after first submission with "Cool, now imagine it needed to handle 10,000 times more (insert thing process handles)". Maybe this should be a pairing session.
        * "Scope it down" but with some component that lends itself to Elixir. e.g. Bulk patient info upload with validation and subsequent edits if there are errors, but drafts last for 36 hours and aren't stored in the DB or something else that forces them to look at ETS, or long-lived processes.
    - Any of these would be fine, but currently "2 days" is difficult to quantify. Finding chunks of hours can draw it out and waste time regaining context if you don't have more than an hour or two here and there.
