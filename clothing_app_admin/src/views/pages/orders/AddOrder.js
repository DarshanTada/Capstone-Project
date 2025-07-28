import React, { useState } from 'react'
import { CCard, CCardBody, CCardHeader, CForm, CFormInput, CButton, CAlert } from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

const AddOrder = () => {
  const [customerName, setCustomerName] = useState('')
  const [totalAmount, setTotalAmount] = useState('')
  const [status, setStatus] = useState('Pending')
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')
    try {
      const res = await axios.post('http://localhost:3001/api/order/create', {
        customerName,
        totalAmount,
        status,
      })
      if (res.data.success) {
        setSuccess('Order created successfully!')
        setTimeout(() => navigate('/orders'), 1000)
      } else {
        setError(res.data.message || 'Failed to create order')
      }
    } catch (err) {
      setError('Failed to create order')
    }
  }

  return (
    <CCard className="mb-4">
      <CCardHeader>
        <strong>Add Order</strong>
      </CCardHeader>
      <CCardBody>
        {error && <CAlert color="danger">{error}</CAlert>}
        {success && <CAlert color="success">{success}</CAlert>}
        <CForm onSubmit={handleSubmit}>
          <CFormInput
            label="Customer Name"
            value={customerName}
            onChange={e => setCustomerName(e.target.value)}
            required
            className="mb-3"
          />
          <CFormInput
            label="Total Amount"
            type="number"
            value={totalAmount}
            onChange={e => setTotalAmount(e.target.value)}
            required
            className="mb-3"
          />
          <CFormInput
            label="Status"
            value={status}
            onChange={e => setStatus(e.target.value)}
            required
            className="mb-3"
          />
          <CButton color="primary" type="submit">Create Order</CButton>
        </CForm>
      </CCardBody>
    </CCard>
  )
}

export default AddOrder