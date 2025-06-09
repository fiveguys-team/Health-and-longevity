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

// 대시보드 views
import adminDashboard from '@/views/dashboard/adminDashboard.vue'
import storeDashboard from '@/views/dashboard/storeDashboard.vue'


// modules/product/views - 입점업체
import ProductRegister from '@/modules/product/views/ProductRegister.vue'
import ProductStatus from '@/modules/product/views/ProductStatus.vue'
import ProductReview from '@/modules/product/views/ProductReview.vue'
import Vendor from '@/views/shop/vendor-category.vue'

// modules/product/views - 관리자
import AdminProductList from '@/modules/product/views/AdminProductList.vue'
import AdminProductDetail from '@/modules/product/views/AdminProductDetail.vue'

// modules/도메인/views/ 하위 test용 view
import LiveStreaming from '@/modules/live/views/LiveStreaming.vue'
import LiveChart from "@/modules/live/views/LiveChart.vue"
import LiveRegister from "@/modules/live/views/LiveRegister.vue"
import StoreLiveStreaming from "@/modules/live/views/StoreLiveStreaming.vue";
import LiveReport from "@/modules/live/views/LiveReport.vue";


import AuthTest from "@/modules/auth/views/AuthTest.vue"
import ChatTest from "@/modules/chat/views/ChatTest.vue"
import ProductTest from "@/modules/product/views/ProductTest.vue"
import ReviewTest from "@/modules/review/views/ReviewTest.vue"
import UserTest from "@/modules/user/views/UserTest.vue"
import OrderView from "@/modules/order/views/OrderView.vue"
import OrderConfirmationView from "@/modules/order/views/OrderConfirmationView.vue"
import PaymentSuccessView from "@/modules/payment/views/PaymentSuccessView.vue"
import PaymentFailureView from "@/modules/payment/views/PaymentFailureView.vue"
import CartView from "@/modules/order/views/CartView.vue"
import OrderHistoryView from "@/modules/order/views/OrderHistoryView.vue"
import PartnerOrderHistoryView from "@/modules/order/views/PartnerOrderHistoryView.vue"
import PartnerReturnRequestView from "@/modules/order/views/PartnerReturnRequestView.vue"
import ShopCart from "@/views/shop/shop-cart.vue";

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


  {path: '/cart',component:ShopCart},
  {path: '/product-details/:id',component:ProductDetails},
  {path: '/checkout',component:CheckoutPage},
  {path: '/contact',component:ContactPage},
  {path: '/product-category',component:ProductCategory},

  { path: "/admin-dashboard", component: adminDashboard },
  { path: "/store-dashboard", component: storeDashboard },

   // 상품, 리뷰 view
  { path: '/products', component: ProductCategory },
  { path: '/product-details/:id', component: ProductDetails },
  {path: '/shop/:category', component: ProductCategory},
  { path: '/product/:category', component: ProductCategory },

   //입점업체
  { path: '/partner/product/register', component: ProductRegister },
  { path: '/partner/product/status', component: ProductStatus },
  { path: '/partner/product/review', component: ProductReview },
  { path: '/vendor/:vendorSlug', component: Vendor},






  // modules/도메인/views/ 하위 test용 view
  {path: '/live-streaming',component: LiveStreaming},
  {path: '/live-chart', component: LiveChart},
  {path: '/live-register', component: LiveRegister},
  {path: '/live-report', component: LiveReport}, 
  // 입점업체 방송 준비 및 송출 페이지
  {path: '/store-live-streaming/:vendorId', component: StoreLiveStreaming},
    
  {path: '/host',
    component: StoreLiveStreaming
  },
  {
    path: '/view/:sessionId',
    name: 'viewer',
    component: LiveStreaming
  },


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
  {path: '/product-test',component: ProductTest},
  {path: '/review-test',component: ReviewTest},
  {path: '/user-test',component: UserTest},

  // 관리자 대시보드 라우트입니다.
  {
    path: "/admin",
    component: () => import("@/views/dashboard/adminDashboard.vue"),
    meta: { requiresAuth: true, adminOnly: true },
    children: [
      {
        path: "chat/reports",
        name: "ChatReportLog",
        component: () => import("@/modules/chat/components/ChatReportLog.vue"),
      },
      {
        path: 'chat/reports',
        name: 'ChatReportLog',
        component: () => import('@/modules/chat/components/ChatReportLog.vue')
      },
      { path: 'products', component: AdminProductList }, //
      { path: 'product/detail/:id', component: AdminProductDetail }
    ],
  },
];





const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
