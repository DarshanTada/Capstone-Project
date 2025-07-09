/* eslint-disable prettier/prettier */
import React, { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  CButton,
  CCard,
  CCardBody,
  CCardGroup,
  CCol,
  CContainer,
  CForm,
  CFormInput,
  CInputGroup,
  CInputGroupText,
  CRow,
  CAlert,
} from '@coreui/react'
import CIcon from '@coreui/icons-react'
import { cilLockLocked, cilUser } from '@coreui/icons'
import { useDispatch } from 'react-redux'

const Login = () => {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [isProcessing, setIsProcessing] = useState(false)

  const dispatch = useDispatch()
  const navigate = useNavigate()

  const handleLogin = async (e) => {
    e.preventDefault()
    setError('')

    // Validate input fields
    if (username.trim() === '') {
      setError('Username is required')
      return
    }

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailPattern.test(username)) {
      setError('Please enter a valid email address')
      return
    }

    if (password.trim() === '') {
      setError('Password is required')
      return
    }

    if (password.length < 4) {
      setError('Password must be at least 4 characters')
      return
    }

    setIsProcessing(true)

    try {
      const response = await fetch('/api/user/loginAdmin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: username, password }),
      })

      const data = await response.json()

      if (response.ok) {
        localStorage.setItem('token', data.accessToken)
        localStorage.setItem('user', JSON.stringify(data.user))
        localStorage.setItem('role', data.user.role)

        dispatch({ type: 'LOGIN_SUCCESS', payload: data.user }) // optional
        navigate('/dashboard') 
      } else {
        if (data.message && data.message.toLowerCase().includes('not found')) {
          setError('User is not registered. Please sign up first.')
        } else {
          setError(data.message || 'Invalid username or password')
        }
      }
    } catch (error) {
      console.error('Error logging in:', error)
      setError('Server error. Please try again later.')
    } finally {
      setIsProcessing(false)
    }
  }

  return (
    <div className="bg-body-tertiary min-vh-100 d-flex flex-row align-items-center">
      <CContainer>
        <CRow className="justify-content-center">
          <CCol md={8}>
            <CCardGroup>
              <CCard className="p-4">
                <CCardBody>
                  <CForm onSubmit={handleLogin}>
                    <h1>Admin Login</h1>
                    <p className="text-body-secondary">Sign in to your admin panel</p>
                    {error && <CAlert color="danger">{error}</CAlert>}
                    <CInputGroup className="mb-3">
                      <CInputGroupText>
                        <CIcon icon={cilUser} />
                      </CInputGroupText>
                      <CFormInput
                        placeholder="Email"
                        autoComplete="username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                      />
                    </CInputGroup>
                    <CInputGroup className="mb-4">
                      <CInputGroupText>
                        <CIcon icon={cilLockLocked} />
                      </CInputGroupText>
                      <CFormInput
                        type="password"
                        placeholder="Password"
                        autoComplete="current-password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                      />
                    </CInputGroup>
                    <CRow>
                      <CCol xs={12}>
                        <CButton color="primary" className="px-4" type="submit" block disabled={isProcessing}>
                          {isProcessing ? 'Logging in...' : 'Login'}
                        </CButton>
                      </CCol>
                    </CRow>
                  </CForm>
                </CCardBody>
              </CCard>
              <CCard className="text-white bg-primary py-5" style={{ width: '44%' }}>
                <CCardBody className="text-center">
                  <div>
                    <h2>Sign up</h2>
                    <p>
                      Don't have an admin account yet? Register now to get access to the admin dashboard and manage your store efficiently.
                    </p>
                    <Link to="/register">
                      <CButton color="primary" className="mt-3" active tabIndex={-1}>
                        Register Now!
                      </CButton>
                    </Link>
                  </div>
                </CCardBody>
              </CCard>
            </CCardGroup>
          </CCol>
        </CRow>
      </CContainer>
    </div>
  )
}

export default Login
