# GbBank
gbbank.co

Demo link: [https://rugged-kobuk-valley-21260.herokuapp.com/](https://rugged-kobuk-valley-21260.herokuapp.com/)

# Assumptions
Since the requirements specified that this should be a simple application, I figure
it'd be best to list the assumptions I've made.

- We're OK with allowing anyone with access to the application to modify members.
That being said, I'd most certainly restrict access to the IP address of the bank.

- The end user isn't concerned with transaction state. Right now, transactions and
member creation are all-or-nothing for simplicity. Alternatively, it could be useful
to persist all transactions and assign various states to them:
`initialized`, `preapproved`, `success`, `failure` etc.

- We aren't operating on a large scale. Right now, I'm making use of locks to ensure
that financial transactions stay in order. This particular implementation doesn't
scale well, especially if we wanted to support sellers charging accounts as that would
require two-way locks. To circumvent that, I'd look into [compensating transactions](https://docs.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction)
or [event sourcing](https://docs.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)

- I'm assuming that transactions cannot be scheduled for future dates. Therefore, a 
valid transaction will have a date:
  - Greater than or equal to the date the account was created
  - Less than or equal today



