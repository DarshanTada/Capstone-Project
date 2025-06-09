import React from 'react'
import { AppContent, AppSidebar, AppFooter, AppHeader } from '../components/index'

const DefaultLayout = () => {
  return (
    <div className="body flex-grow-1">
      <AppContent />
    </div>
  )
}

export default DefaultLayout
