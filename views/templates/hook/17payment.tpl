{*
 * 2016 Michael Dekker
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@michaeldekker.com so we can send you a copy immediately.
 *
 *  @author    Michael Dekker <prestashop@michaeldekker.com>
 *  @copyright 2016 Michael Dekker
 *  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}
<!-- mdstripe views/templates/hook/17payment.tpl -->
<div class="row">
	<form id="stripe-form" action="{$stripe_confirmation_page|escape:'htmlall':'UTF-8'}" method="POST">
		<input type="hidden" name="id_cart" value="{$id_cart|escape:'htmlall':'UTF-8'}">
	</form>
	<a id="mdstripe_payment_link" href="#" title="{l s='Pay with Stripe' mod='mdstripe'}" class="btn btn-info">
		<i class="material-icons">&#xE870;</i> <span class="stripe-call-to-action">{l s='Pay with Stripe' mod='mdstripe'}</span>
	</a>
	<script type="text/javascript">
		(function() {
			var handler = null;

			function openStripeHandler(e) {
				{* Open Checkout with further options: *}
				handler.open({
					name: '{$stripe_shopname|escape:'javascript':'UTF-8'}',
					zipCode: {if $stripe_zipcode}true{else}false{/if},
					bitcoin: {if $stripe_bitcoin}true{else}false{/if},
					alipay: {if $stripe_alipay}true{else}false{/if},
					currency: '{$stripe_currency|escape:'javascript':'UTF-8'}',
					amount: '{$stripe_amount|escape:'javascript':'UTF-8'}',
					email: '{$stripe_email|escape:'javascript':'UTf-8'}',
					billingAddress: {if $stripe_collect_billing}true{else}false{/if},
					shippingAddress: {if $stripe_collect_shipping}true{else}false{/if}
				});
				if (typeof e !== 'undefined' && typeof e !== 'function') {
					e.preventDefault();
				}
			}

			function initStripeCheckout() {
				if (typeof StripeCheckout === 'undefined') {
					setTimeout(initStripeCheckout, 100);
					return;
				}

				handler = StripeCheckout.configure({
					key: '{$stripe_publishable_key|escape:'javascript':'UTF-8'}',
					image: '{$stripeShopThumb|escape:'javascript':'UTF-8'}',
					locale: '{$stripe_locale|escape:'javascript':'UTF-8'}',
					token: function (token) {
						{* Insert the token into the form so it gets submitted to the server: *}
						$stripeinput = $('input[name=mdstripe-token]');
						$stripeinput.val(token.id);

						$button = $('#mdstripe_payment_link');
						$button.removeClass('btn-primary');
						$button.addClass('btn-success');
						$button.find('.stripe-call-to-action').html('{l s='Change card' mod='mdstripe'}');
					}
				});

				$('#mdstripe_payment_link').click(openStripeHandler);
			}

			initStripeCheckout();
		})();
	</script>
</div>
<!-- /mdstripe views/templates/hook/17payment.tpl -->
