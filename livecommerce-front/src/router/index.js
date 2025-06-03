import { createRouter, createWebHistory } from 'vue-router'
import IndexOne from '@/views/index/index-one.vue'
import AboutUs from '@/views/inner-pages/about-us.vue'
import PricingPage from '@/views/inner-pages/pricing-page.vue'
import TeamPage from '@/views/inner-pages/team-page.vue'
import OurClients from '@/views/inner-pages/our-clients.vue'
import FaqPage from '@/views/inner-pages/faq-page.vue'
import TermsAndConditions from '@/views/inner-pages/terms-and-conditions.vue'
import ErrorPage from '@/views/special/error-page.vue'
import MyProfile from '@/views/profile/my-profile.vue'
import MyAccount from '@/views/profile/my-account.vue'
import EditAccount from '@/views/profile/edit-account.vue'
import WishlistPage from '@/views/profile/wishlist-page.vue'
import LoginPage from '@/views/auth/login-page.vue'
import RegisterPage from '@/views/auth/register-page.vue'
import ForgerPassword from '@/views/auth/forger-password.vue'
import ComingSoon from '@/views/special/coming-soon.vue'
import ThankYou from '@/views/special/thank-you.vue'
import ShippingMethod from '@/views/shop/shipping-method.vue'
import PaymentMethod from '@/views/shop/payment-method.vue'
import InvoicePage from '@/views/shop/invoice-page.vue'
import ShopV1 from '@/views/shop/shop-v1.vue'
import ProductDetails from '@/views/shop/product-details.vue'
import CheckoutPage from '@/views/shop/checkout-page.vue'
import ContactPage from '@/views/inner-pages/contact-page.vue'
import ProductCategory from '@/views/shop/product-category.vue'

// modules/도메인/views/ 하위 test용 view
import LiveTest from '@/modules/live/views/LiveTest.vue'
import AuthTest from '@/modules/auth/views/AuthTest.vue'
import ChatTest from '@/modules/chat/views/ChatTest.vue'
import OrderView from '@/modules/order/views/OrderView.vue'
import ProductTest from '@/modules/product/views/ProductTest.vue'
import ReviewTest from '@/modules/review/views/ReviewTest.vue'
import UserTest from '@/modules/user/views/UserTest.vue'
import OrderConfirmationView from "@/modules/order/views/OrderConfirmationView.vue";
import PaymentSuccessView from "@/modules/payment/views/PaymentSuccessView.vue";
import PaymentFailureView from "@/modules/payment/views/PaymentFailureView.vue";
import CartView from "@/modules/order/views/CartView.vue";
import OrderHistoryView from "@/modules/order/views/OrderHistoryView.vue";
import PartnerOrderHistoryView from "@/modules/order/views/PartnerOrderHistoryView.vue";
import PartnerReturnRequestView from "@/modules/order/views/PartnerReturnRequestView.vue";

const routes = [
  {path: '/',component: IndexOne},
  {path: '/about',component: AboutUs},
  {path: '/pricing',component: PricingPage},
  {path: '/team',component: TeamPage},
  {path: '/our-clients',component: OurClients},
  {path: '/faq',component: FaqPage},
  {path: '/terms-and-conditions',component: TermsAndConditions},
  {path: '/error',component: ErrorPage},
  {path: '/my-profile',component: MyProfile},
  {path: '/my-account',component: MyAccount},
  {path: '/edit-account',component: EditAccount},
  {path: '/wishlist',component: WishlistPage},
  {path: '/login',component:LoginPage},
  {path: '/register',component:RegisterPage},
  {path: '/forger-password',component:ForgerPassword},
  {path: '/coming-soon',component:ComingSoon},
  {path: '/thank-you',component:ThankYou},
  {path: '/shipping-method',component:ShippingMethod},
  {path: '/payment-method',component:PaymentMethod},
  {path: '/invoice',component:InvoicePage},
  {path: '/shop-v1',component:ShopV1},
  {path: '/product-details',component:ProductDetails},
  {path: '/product-details/:id',component:ProductDetails},
  {path: '/checkout',component:CheckoutPage},
  {path: '/contact',component:ContactPage},
  {path: '/product-category',component:ProductCategory},
  
  // modules/도메인/views/ 하위 test용 view
  {path: '/live-test',component: LiveTest},
  {path: '/auth-test',component: AuthTest},
  {path: '/chat-test',component: ChatTest},
  {path: '/order',component: OrderView},
  {path: '/order-confirmation',component: OrderConfirmationView},
  {path: '/order-history',component: OrderHistoryView},
  {path: '/partner/order-history',component: PartnerOrderHistoryView},
  {path: '/partner/return-request',component: PartnerReturnRequestView},
  {path: '/cart',component: CartView},
  {path: '/payment-success',component: PaymentSuccessView},
  {path: '/payment-failure',component: PaymentFailureView},
  {path: '/product-test',component: ProductTest},
  {path: '/review-test',component: ReviewTest},
  {path: '/user-test',component: UserTest}
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
