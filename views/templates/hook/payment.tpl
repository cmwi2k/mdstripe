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
<!-- mdstripe views/templates/hook/payment.tpl -->
{if $stripe_checkout}
	{if $smarty.const._PS_VERSION_|@addcslashes:'\'' < '1.6'}
		<form id="stripe-form" action="{$stripe_confirmation_page|escape:'htmlall':'UTF-8'}" method="POST">
			<input type="hidden" name="mdstripe-id_cart" value="{$id_cart|escape:'htmlall':'UTF-8'}">
		</form>
		<p class="payment_module" id="mdstripe_payment_button">
			<a id="mdstripe_payment_link" href="#" title="{l s='Pay with Stripe' mod='mdstripe'}">
				<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/stripebtnlogo15.png" alt="{l s='Pay with Stripe' mod='mdstripe'}" width="108" height="46" />
				{l s='Pay with Stripe' mod='mdstripe'}
				{if $showPaymentLogos}
					<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/creditcards.png" alt="{l s='Credit cards' mod='mdstripe'}" />
					{if $stripe_alipay}<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/alipay.png" alt="{l s='Alipay' mod='mdstripe'}" />{/if}
					{if $stripe_bitcoin}<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/bitcoin.png" alt="{l s='Bitcoin' mod='mdstripe'}" />{/if}
				{/if}
			</a>
		</p>
	{else}
		<div class="row">
			<form id="stripe-form" action="{$stripe_confirmation_page|escape:'htmlall':'UTF-8'}" method="POST">
				<input type="hidden" name="mdstripe-id_cart" value="{$id_cart|escape:'htmlall':'UTF-8'}">
			</form>
			<div class="col-xs-12 col-md-12">
				<p class="payment_module" id="mdstripe_payment_button">
					<a id="mdstripe_payment_link" href="#" title="{l s='Pay with Stripe' mod='mdstripe'}">
						<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/stripebtnlogo.png" alt="{l s='Pay with Stripe' mod='mdstripe'}" width="64" height="64" />
						{l s='Pay with Stripe' mod='mdstripe'}
						{if $showPaymentLogos}
							<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/creditcards.png" alt="{l s='Credit cards' mod='mdstripe'}" />
							{if $stripe_alipay}<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/alipay.png" alt="{l s='Alipay' mod='mdstripe'}" />{/if}
							{if $stripe_bitcoin}<img src="{$module_dir|escape:'htmlall':'UTF-8'}/views/img/bitcoin.png" alt="{l s='Bitcoin' mod='mdstripe'}" />{/if}
						{/if}
					</a>
				</p>
			</div>
		</div>
	{/if}
{/if}

<script type="text/javascript">
	(function() {
		function initStripeCheckout() {
			if (typeof StripeCheckout === 'undefined') {
				setTimeout(initStripeCheckout, 100);
				return;
			}

			var handler = StripeCheckout.configure({
				key: '{$stripe_publishable_key|escape:'javascript':'UTF-8'}',
				image: '{$stripeShopThumb|escape:'javascript':'UTF-8'}',
				locale: 'auto',
				token: function (token) {
					var $form = $('#stripe-form');
					{* Insert the token into the form so it gets submitted to the server: *}
					$form.append($('<input type="hidden" name="mdstripe-token" />').val(token.id));

					{* Submit the form: *}
					$form.get(0).submit();
				}
			});

			$('#mdstripe_payment_link').on('click', function (e) {
				{* Open Checkout with further options: *}
				handler.open({
					name: '{$stripe_shopname|escape:'javascript':'UTF-8'}',
					zipCode: {if $stripe_zipcode}true{else}false{/if},
					bitcoin: {if $stripe_bitcoin}true{else}false{/if},
					alipay: {if $stripe_alipay}true{else}false{/if},
					currency: '{$stripe_currency|escape:'javascript':'UTF-8'}',
					amount: {$stripe_amount|floatval},
					email: '{$stripe_email|escape:'javascript':'UTf-8'}',
					billingAddress: {if $stripe_collect_billing}true{else}false{/if},
					shippingAddress: {if $stripe_collect_shipping}true{else}false{/if}
				});
				e.preventDefault();
			});
		}

		initStripeCheckout();
	})();
</script>
