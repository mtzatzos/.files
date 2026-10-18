# Global instructions

## Writing style

Always write in ASD-STE100 Simplified Technical English. This applies to all prose: replies, documentation, code comments, commit messages and pull request descriptions.

## Design: prefer deep modules over shallow ones

When writing or refactoring code, aim for **deep modules**: a small, simple interface that hides a large amount of implementation. Avoid **shallow modules**, whose interface is nearly as complex as what they do. (Ousterhout, *A Philosophy of Software Design*.)

- Judge a module by how much it does relative to how much a caller must know to use it.
- Pull complexity downward. The module should absorb the hard parts (business rules, edge cases, defaults, side effects) so callers don't have to.
- Don't leak implementation details through the interface: internal types, config knobs most callers don't need, low-level exceptions.
- Avoid pass-through methods and thin wrappers that just forward calls with the same signature.
- Don't split classes or functions purely to make them smaller. Split when it produces simpler interfaces, not more of them.
- Prefer defining errors out of existence (sensible defaults, idempotent operations) over making callers handle many cases.
- Deep is not the same as god-class. A deep module still has one coherent responsibility.
- If a change makes callers coordinate several objects in a specific order, treat that as a sign the module is too shallow.

### Example

Shallow: the caller has to know the business rules and apply them in the right order.

```java
if (!refundPolicy.isWithinWindow(order, clock.now())) throw new RefundNotAllowedException();
if (order.status() == SHIPPED && !returnService.isReceived(order)) throw new ReturnPendingException();
var amount = refundCalculator.itemsTotal(order, items);
amount = refundCalculator.subtractRestockingFee(amount, order.customer().tier());
amount = refundCalculator.addShippingIfFullRefund(amount, order, items);
inventoryService.restock(items);
order.setStatus(order.allRefunded(items) ? REFUNDED : PARTIALLY_REFUNDED);
paymentGateway.refund(order.paymentId(), amount);
events.publish(new OrderRefunded(order.id(), amount));
```

Deep: one intention-revealing call. The module owns eligibility, amount rules, state transitions and side effects.

```java
RefundResult result = refunds.refund(orderId, items, reason);
// result.amount(), result.status(), or result.rejection() (e.g. OUTSIDE_WINDOW, RETURN_PENDING)
```

New rules (holiday return windows, tier-based fees) change only the inside of `refunds`, never its callers.
