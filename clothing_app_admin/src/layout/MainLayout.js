/* eslint-disable prettier/prettier */
import React from 'react'
import Header from '../components/AppHeader'
import Footer from '../components/AppFooter'
import AppSidebar from '../components/AppSidebar'
import AppContent from '../components/AppContent'

const MainLayout = () => (
  <div>
    <AppSidebar />
    <div className="wrapper d-flex flex-column min-vh-100">
      <Header />
      <div className="body flex-grow-1">
        <AppContent />
      </div>
      <Footer />
    </div>
  </div>
)

export default MainLayout