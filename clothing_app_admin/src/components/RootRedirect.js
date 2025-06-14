/* eslint-disable prettier/prettier */
import React from 'react'
import { Navigate } from 'react-router-dom'
import { useSelector } from 'react-redux'

const RootRedirect = () => {
  const isLoggedIn = useSelector((state) => state.auth?.isLoggedIn) // Adjust according to your auth state
  return isLoggedIn ? <Navigate to="/dashboard" replace /> : <Navigate to="/login" replace />
}

export default RootRedirect