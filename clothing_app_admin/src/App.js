/* eslint-disable prettier/prettier */
import React, { Suspense, useEffect } from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { useSelector } from 'react-redux'
import { CSpinner, useColorModes } from '@coreui/react'
import './scss/style.scss'

// We use those styles to show code examples, you should remove them in your application.
import './scss/examples.scss'

// Containers
const MainLayout = React.lazy(() => import('./layout/MainLayout'))// ...existing imports...


// Pages
const Login = React.lazy(() => import('./views/pages/login/Login'))
const Page404 = React.lazy(() => import('./views/pages/page404/Page404'))
import AddOrder from './views/pages/orders/AddOrder'
const AddProduct = React.lazy(() => import('./views/pages/products/AddProduct'))


const App = () => {
  const { isColorModeSet, setColorMode } = useColorModes('coreui-free-react-admin-template-theme')
  const storedTheme = useSelector((state) => state.theme)
  const isLoggedIn = useSelector((state) => state.isLoggedIn)

  useEffect(() => {
    if (isColorModeSet()) return
    setColorMode(storedTheme)
  }, []) // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <BrowserRouter>
      <Suspense
        fallback={
          <div className="pt-3 text-center">
            <CSpinner color="primary" variant="grow" />
          </div>
        }
      >
        <Routes>
          <Route path="/login" element={isLoggedIn ? <Navigate to="/" replace /> : <Login />} />
          <Route
            path="/*"
            element={
              isLoggedIn ? (
                <MainLayout />
              ) : (
                <Navigate to="/login" replace />
              )
            }
          >
            {/* Nested routes inside MainLayout */}
            <Route path="orders/add" element={<AddOrder />} />
            <Route path="products/add" element={<AddProduct />} />
            {/* You can add more nested routes here if needed */}
          </Route>
          <Route path="*" element={<Page404 />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  )
}

export default App
