import {createRouter, createWebHashHistory} from 'vue-router'
import { useAuthStore } from "@/modules/auth/stores/auth";
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

//테스트용 vue


// 대시보드 views
import adminDashboard from '@/views/dashboard/adminDashboard.vue'


// modules/product/views - 입점업체
import ProductStatus from '@/modules/product/views/ProductStatus.vue'
import ProductReview from '@/modules/product/views/ProductReview.vue'
import Vendor from '@/views/shop/vendor-category.vue'



// modules/도메인/views/ 하위 test용 view
import LiveStreaming from '@/modules/live/views/LiveStreaming.vue'
import LiveChart from "@/modules/live/views/LiveStreamList.vue"
import LiveRegister from "@/modules/live/views/LiveRegister.vue"
import StoreLiveStreaming from "@/modules/live/views/StoreLiveStreaming.vue";
import LiveReport from "@/modules/live/components/LiveReport.vue";


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
import test from "@/modules/live/views/testView.vue";
import OAuthSuccess from "@/modules/auth/views/OAuthSuccess.vue";
import CheckoutCartView from "@/modules/order/views/CheckoutCartView.vue";
import PaymentCartSuccessView from "@/modules/payment/views/PaymentCartSuccessView.vue";

const routes = [
  {path: '/',component: IndexOne},
  {path: '/about',component: AboutUs},
  {path: '/pricing',component: PricingPage},
  {path: '/team',component: TeamPage},
  {path: '/our-clients',component: OurClients},
  {path: '/faq',component: FaqPage},
  {path: '/terms-and-conditions',component: TermsAndConditions},
  {path: '/error',component: ErrorPage},
  {path: '/my-profile',component: MyProfile, meta: {requiresAuth: true}},
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


  {path: '/cart',component:CartView},
  // 상품 상세 페이지 라우트 (중복 제거)
  {
    path: '/product-details/:id',
    name: 'ProductDetails',
    component: ProductDetails,
    props: true
  },
  {path: '/checkout',component:CheckoutPage},
  {path: '/contact',component:ContactPage,
    meta: {requiresAuth: true, roles: ['USER']}
  },
  {path: '/product-category',component:ProductCategory},
  {path: '/oauth-success', component:OAuthSuccess},

  { path: "/admin-dashboard", component: adminDashboard,
    meta: {requiresAuth: true, roles: ['ADMIN']},
    redirect: '/admin-dashboard/dashboard',
    children: [
      {
        path: "dashboard",
        name: "adminDashboardMain",
        component: () => import("@/components/dashboard/adminDashboardComponent.vue"),
      },
      {
        path: "chat/reports",
        name: "ChatReportLog",
        component: () => import("@/modules/chat/components/ChatReportLog.vue"),
      },
      {
        path: 'products',
        name: 'AdminProductList',
        component: () => import('@/modules/product/views/AdminProductList.vue')
      },
      {
        path: 'product/detail/:id',
        name: 'AdminProductDetail',
        component: () => import('@/modules/product/views/AdminProductDetail.vue'),
        props: true
      },
      {
        path: 'vendor-management',
        name: 'VendorManagement',
        component: () => import('@/views/dashboard/admin/vendorManagement.vue'),
      },
    ]
  },
  //{ path: "/store-dashboard", component: storeDashboard },

  // 상품, 리뷰 view
  { path: '/products', component: ProductCategory },
  { path: '/shop/:category', component: ProductCategory},
  { path: '/product/:category', component: ProductCategory },
  { path: '/vendor/:vendorSlug', component: Vendor },
  { path: '/vendor-category', component: () => import('@/views/shop/vendor-category.vue')},

  {
    path: '/vendor/:vendorId/products',
    name: 'VendorProductList',
    component: () => import('@/views/shop/vendor-products.vue'),
    props: true
  },

  //입점업체
  //{ path: '/partner/product/register', component: ProductRegister },
  { path: '/partner/product/status', component: ProductStatus },
  { path: '/partner/product/review', component: ProductReview },
  { path: '/vendor/:vendorSlug', component: Vendor},





  // modules/도메인/views/ 하위 test용 view
  {path: '/live-streaming',component: test},
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
  {
    path: '/order',
    name: 'order',
    component: OrderView,
    props: route => ({
      productId: route.query.productId,
      quantity: Number(route.query.quantity) || 1
    }),
  },
  {path: '/order-confirmation',component: OrderConfirmationView},
  {path: '/order-history',component: OrderHistoryView},
  {path: '/partner/order-history',component: PartnerOrderHistoryView},
  {path: '/partner/return-request',component: PartnerReturnRequestView},
  {path: '/cart',component: CartView},
  {path: '/cart-checkout',component: CheckoutCartView},
  {path: '/payment-success',component: PaymentSuccessView},
  {path: '/payment-success-cart',component: PaymentCartSuccessView},
  {path: '/payment-failure',component: PaymentFailureView},
  {path: '/product-test',component: ProductTest},
  {path: '/product-test',component: ProductTest},
  {path: '/review-test',component: ReviewTest},
  {path: '/user-test',component: UserTest},

  // 관리자 대시보드 라우트입니다.
  {
    path: "/admin",
    redirect: "/admin-dashboard"
  },

  // 입점업체 대시보드 라우트입니다.
  {
    path: "/vendor",
    component: () => import("@/views/dashboard/storeDashboard.vue"),
    meta: { requiresAuth: true, roles: ['VENDOR'] },
    children: [
      {
        path: "live/reportList/:vendorId",
        name: "reportList",
        component: () => import("@/modules/live/components/LiveReport.vue"),
      },

      {
        path: "product/register",
        name: "VendorProductRegister",
        component: () => import("@/modules/product/views/ProductRegister.vue"),
      },
      {
        path: "product/status",
        name: "VendorProductStatus",
        component: () => import("@/modules/product/views/ProductStatus.vue"),
      },
      {
        path: "product/detail/:id",
        name: "VendorProductDetail",
        component: () => import("@/modules/product/views/ProductStatus.vue"),
      }

    ],
  },



  {
    path: '/store-dashboard',
    component: () => import('@/views/dashboard/storeDashboard.vue'), // 이건 그대로 레이아웃 역할
    meta: {requiresAuth: true, roles: ['VENDOR']},
    children: [
      {
        path: 'product/register',
        component: () => import('@/modules/product/views/ProductRegister.vue')
      },
      {
        path: 'product/status',
        component: () => import('@/modules/product/views/ProductStatus.vue')
      },
      {
        path: 'product/review',
        component: () => import('@/modules/product/views/ProductReview.vue')
      }
    ]
  },

  // 채팅 라우트
  {
    path: '/chat',
    name: 'chat',
    component: () => import('@/modules/chat/components/ChatContainer.vue'),
  },
];

const router = createRouter({
  history: createWebHashHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  try {
    // 사용자 정보가 없으면 서버에서 불러옴
    if (!authStore.role) {
      await authStore.initFromServer()
    }

    // 인증이 필요한 페이지 접근 시 체크
    if (to.meta?.requiresAuth) {
      if (!authStore.id) {
        return next('/login')
      }

      if (to.meta.roles && !to.meta.roles.includes(authStore.role)) {
        alert('권한이 없습니다.')
        return next('/error') // 권한 부족 시 error 페이지로 이동
      }
    }

    next()
  } catch (e) {
    console.warn('initFromServer or auth check failed:', e)
    // 에러 발생 시 공통 에러 페이지로 이동
    return next('/error')
  }
})


export default router;
