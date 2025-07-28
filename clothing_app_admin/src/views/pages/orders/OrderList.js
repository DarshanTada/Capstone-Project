import React, { useEffect, useState } from 'react'
import { CCard, CCardBody, CCardHeader, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell, CPagination, CPaginationItem, CButton, CFormInput } from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import AddOrder from './AddOrder'

const OrderList = () => {
  const [orders, setOrders] = useState([])
  const [search, setSearch] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [ordersPerPage, setOrdersPerPage] = useState(10)
  const [showAddOrder, setShowAddOrder] = useState(false)
  const navigate = useNavigate()

  useEffect(() => {
    axios.get('http://localhost:3001/api/order/list')
      .then(res => {
        if (res.data.success) {
          setOrders(res.data.orders)
        }
      })
      .catch(err => {
        console.error('Failed to fetch orders:', err)
      })
  }, [])

  const handleDelete = async (orderId) => {
    if (window.confirm('Are you sure you want to delete this order?')) {
      try {
        await axios.delete(`http://localhost:3001/api/order/${orderId}`)
        setOrders(orders.filter(order => order._id !== orderId))
      } catch (err) {
        alert('Failed to delete order.')
      }
    }
  }

  const filteredOrders = orders.filter(order =>
    (order.customerName && order.customerName.toLowerCase().includes(search.toLowerCase())) ||
    (order._id && order._id.toLowerCase().includes(search.toLowerCase()))
  )

  const totalPages = Math.ceil(filteredOrders.length / ordersPerPage)
  const paginatedOrders = filteredOrders.slice(
    (currentPage - 1) * ordersPerPage,
    currentPage * ordersPerPage
  )

  const handlePageChange = (page) => {
    if (page >= 1 && page <= totalPages) setCurrentPage(page)
  }

  const handleSearchChange = (e) => {
    setSearch(e.target.value)
    setCurrentPage(1)
  }

  const handleOrdersPerPageChange = (e) => {
    setOrdersPerPage(Number(e.target.value))
    setCurrentPage(1)
  }

  const pageOptions = [2, 3, 5, 10, 15, 20, 25, 50].filter(num => num < filteredOrders.length)
  if (filteredOrders.length > 0) pageOptions.push(filteredOrders.length)

  return (
    <CCard className="mb-4">
      <CCardHeader className="d-flex justify-content-between align-items-center">
        <strong>Order Management</strong>
        <div>
          <label htmlFor="ordersPerPage" className="me-2">Orders per page:</label>
          <select
            id="ordersPerPage"
            value={ordersPerPage}
            onChange={handleOrdersPerPageChange}
            className="form-select d-inline-block w-auto"
          >
            {pageOptions.map((num) => (
              <option key={num} value={num}>
                {num === filteredOrders.length ? 'All' : num}
              </option>
            ))}
          </select>
          <CButton color="primary" className="float-end ms-3" onClick={() => navigate('/orders/add')}>
            Add Order
          </CButton>
        </div>
      </CCardHeader>
      <CCardBody>
        <div className="mb-3 d-flex justify-content-end">
          <CFormInput
            type="text"
            placeholder="Search by customer or order ID"
            value={search}
            onChange={handleSearchChange}
            style={{ maxWidth: 300 }}
          />
        </div>
        <CTable align="middle" className="mb-0 border" hover responsive>
          <CTableHead>
            <CTableRow>
              <CTableHeaderCell>Order ID</CTableHeaderCell>
              <CTableHeaderCell>Customer</CTableHeaderCell>
              <CTableHeaderCell>Status</CTableHeaderCell>
              <CTableHeaderCell>Total</CTableHeaderCell>
              <CTableHeaderCell>Date</CTableHeaderCell>
              <CTableHeaderCell>Actions</CTableHeaderCell>
            </CTableRow>
          </CTableHead>
          <CTableBody>
            {paginatedOrders.map((order, idx) => (
              <CTableRow key={order._id || idx}>
                <CTableDataCell>{order._id}</CTableDataCell>
                <CTableDataCell>{order.customerName}</CTableDataCell>
                <CTableDataCell>{order.status}</CTableDataCell>
                <CTableDataCell>{order.totalAmount}</CTableDataCell>
                <CTableDataCell>{order.createdAt && new Date(order.createdAt).toLocaleString()}</CTableDataCell>
                <CTableDataCell>
                  <CButton color="info" size="sm" className="me-2" onClick={() => navigate(`/orders/${order._id}`)}>
                    View
                  </CButton>
                  <CButton color="danger" size="sm" onClick={() => handleDelete(order._id)}>
                    Delete
                  </CButton>
                </CTableDataCell>
              </CTableRow>
            ))}
          </CTableBody>
        </CTable>
        <CPagination className="justify-content-center my-3">
          <CPaginationItem disabled={currentPage === 1} onClick={() => handlePageChange(currentPage - 1)}>
            Previous
          </CPaginationItem>
          {[...Array(totalPages)].map((_, idx) => (
            <CPaginationItem
              key={idx + 1}
              active={currentPage === idx + 1}
              onClick={() => handlePageChange(idx + 1)}
            >
              {idx + 1}
            </CPaginationItem>
          ))}
          <CPaginationItem disabled={currentPage === totalPages} onClick={() => handlePageChange(currentPage + 1)}>
            Next
          </CPaginationItem>
        </CPagination>
      </CCardBody>
    </CCard>
  )
}

export default OrderList