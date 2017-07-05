# GbBank
gbbank.co

Demo link: [https://rugged-kobuk-valley-21260.herokuapp.com/](https://rugged-kobuk-valley-21260.herokuapp.com/)

# Setup
Locally, seeds can be created with `rails db:seed`

Tests can be run with `bundle exec rspec`
(API request specs are present, but not exhaustive)

# Design
I've opted for a fairly simple design for this banking application by making
assumptions based on the nature of the challenge. The implementation would wildly
differ based on real-world requirements such as concurrency, metrics, security,
data attribution models, etc.

Upon creation, a *Member* will have an *Account* created for them. This *Account*
serves as a "grouping" for their *Transactions*, as well as, a cache for their balance. The
undisputed ledger for their balance would always be the sum of their *Transactions*. To maintain
consistency between the *Account* balance and the *Transactions*, I've made use
of database transactions and locks.

This particular implementation doesn't scale well, especially if we wanted
to support sellers charging accounts as that would require two-way locks.
To circumvent that, I'd look into [compensating transactions](https://docs.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction)
or [event sourcing](https://docs.microsoft.com/en-us/azure/architecture/patterns/event-sourcing).


# Assumptions

- We're OK with allowing anyone with access to the application to modify members.
That being said, I'd most certainly restrict access to the IP address of the bank.

- The end user isn't concerned with transaction state. Right now, transactions and
member creation are all-or-nothing for simplicity. Alternatively, it could be useful
to assign various states to a *Transaction*.

- I'm assuming that *Transactions* cannot be scheduled for future dates. Therefore, a
valid transaction will have a date:
  - Greater than or equal to the date the account was created
  - Less than or equal today



# JSON endpoints
For authentication, I've implemented a very basic form of token authentication. To
authorize, use the token `acompletelynotsafetoken`.

- List members  - GET api/v1/members
- Create member - POST api/v1/members
  - `{"name": "Great Name", "email": "great@name.com" }`
- Edit members  - PUT api/v1/members/:id
  - `{"name": "Great Name", "email": "great@name.com" }`
- Create transaction - POST api/v1/transaction (required: member.email, amount, date, description)
  - ```
    { "member": { email": "great@name.com" },
      "amount": 10.00,
      "date": "2017-07-05",
      "description": "All the mangos"
    }
    ```

Example cURL request to create transaction:
```
  curl --request POST \
    --url http://localhost:3000/api/v1/transactions \
    --header 'content-type: application/json' \
    --header 'authorization: Bearer acompletelynotsafetoken' \
    --data '{"member": {"email": "darrion@schroeder.org"},"amount": 100.00,"date": "2017-07-04","description": "STUFFF"}'
```
