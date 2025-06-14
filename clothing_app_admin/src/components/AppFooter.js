import React from 'react'
import { CFooter } from '@coreui/react'

const AppFooter = () => {
  return (
    <CFooter className="px-4">
      <div>
        <a href="https://yolochic.com" target="_blank" rel="noopener noreferrer">
          YOLO CHIC
        </a>
      </div>
      <div className="ms-auto">
        <span className="ms-1">Copyright &copy; 2025 Yolo Chic - All Rights Reserved.</span>
      </div>
      <div className="ms-auto">
        <span className="me-1">Admin Dashboard</span>
      </div>
    </CFooter>
  )
}

export default React.memo(AppFooter)
