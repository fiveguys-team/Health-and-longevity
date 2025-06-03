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
import OrderHistory from '@/views/profile/order-history.vue'
import WishlistPage from '@/views/profile/wishlist-page.vue'
import LoginPage from '@/views/auth/login-page.vue'
import RegisterPage from '@/views/auth/register-page.vue'
import ForgerPassword from '@/views/auth/forger-password.vue'
import ComingSoon from '@/views/special/coming-soon.vue'
import ThankYou from '@/views/special/thank-you.vue'
import ShippingMethod from '@/views/shop/shipping-method.vue'
import PaymentMethod from '@/views/shop/payment-method.vue'
import InvoicePage from '@/views/shop/invoice-page.vue'
import PaymentConfirmation from '@/views/shop/payment-confirmation.vue'
import PaymentSuccess from '@/views/shop/payment-success.vue'
import PaymentFailure from '@/views/shop/payment-failure.vue'
import ShopV1 from '@/views/shop/shop-v1.vue'
import ProductDetails from '@/views/shop/product-details.vue'
import ShopCart from '@/views/shop/shop-cart.vue'
import CheckoutPage from '@/views/shop/checkout-page.vue'
import ContactPage from '@/views/inner-pages/contact-page.vue'
import ProductCategory from '@/views/shop/product-category.vue'

// 대시보드 views
import adminDashboard from '@/views/dashboard/adminDashboard.vue'
import storeDashboard from '@/views/dashboard/storeDashboard.vue'



// modules/도메인/views/ 하위 test용 view
import LiveTest from '@/modules/live/views/LiveTest.vue'
import AuthTest from '@/modules/auth/views/AuthTest.vue'
import ChatTest from '@/modules/chat/views/ChatTest.vue'
import OrderTest from '@/modules/order/views/OrderTest.vue'
import PaymentTest from '@/modules/payment/views/PaymentTest.vue'
import ProductTest from '@/modules/product/views/ProductTest.vue'
import ReviewTest from '@/modules/review/views/ReviewTest.vue'
import UserTest from '@/modules/user/views/UserTest.vue'

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
  {path: '/order-history',component: OrderHistory},
  {path: '/wishlist',component: WishlistPage},
  {path: '/login',component:LoginPage},
  {path: '/register',component:RegisterPage},
  {path: '/forger-password',component:ForgerPassword},
  {path: '/coming-soon',component:ComingSoon},
  {path: '/thank-you',component:ThankYou},
  {path: '/shipping-method',component:ShippingMethod},
  {path: '/payment-method',component:PaymentMethod},
  {path: '/invoice',component:InvoicePage},
  {path: '/payment-confirmation',component:PaymentConfirmation},
  {path: '/payment-success',component:PaymentSuccess},
  {path: '/payment-failure',component:PaymentFailure},
  {path: '/shop-v1',component:ShopV1},
  {path: '/product-details',component:ProductDetails},
  {path: '/product-details/:id',component:ProductDetails},
  {path: '/cart',component:ShopCart},
  {path: '/checkout',component:CheckoutPage},
  {path: '/contact',component:ContactPage},
  {path: '/product-category',component:ProductCategory},

  {path: '/admin-dashboard', component: adminDashboard},
  {path: '/store-dashboard', component: storeDashboard},




  
  // modules/도메인/views/ 하위 test용 view
  {path: '/live-test',component: LiveTest},
  {path: '/auth-test',component: AuthTest},
  {path: '/chat-test',component: ChatTest},
  {path: '/order-test',component: OrderTest},
  {path: '/payment-test',component: PaymentTest},
  {path: '/product-test',component: ProductTest},
  {path: '/review-test',component: ReviewTest},
  {path: '/user-test',component: UserTest}
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
