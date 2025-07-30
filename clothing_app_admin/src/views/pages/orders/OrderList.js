import React, { useEffect, useState } from 'react'
import { CCard, CCardBody, CCardHeader, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell, CPagination, CPaginationItem, CButton, CFormInput } from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

const OrderList = () => {
  const [apiError, setApiError] = useState('');
  // Update order status handler
  // Update product item status handler
  const handleProductStatusChange = async (orderId, variantId, newStatus) => {
    try {
      const res = await axios.put('http://localhost:3001/api/order/updateProductStatus', {
        orderId,
        variantId,
        status: newStatus
      });
      if (res.data.success) {
        setOrders(prevOrders => prevOrders.map(order => {
          if (order._id !== orderId) return order;
          return {
            ...order,
            products: order.products.map(product =>
              product.variantId === variantId ? { ...product, status: newStatus } : product
            )
          };
        }));
      } else {
        alert(res.data.message || 'Failed to update product status');
      }
    } catch (err) {
      alert('Failed to update product status');
    }
  }
  const [orders, setOrders] = useState([])
  const [search, setSearch] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [ordersPerPage, setOrdersPerPage] = useState(10)
  const navigate = useNavigate()
  // Example: get user role from localStorage, context, or props
  const userRole = localStorage.getItem('userRole') || 'user';

  useEffect(() => {
    axios.post('http://localhost:3001/api/order/getAllOrders', { page: 1, limit: 100 })
      .then(res => {
        if (res.data.success) {
          setOrders(res.data.data || [])
          setApiError('');
        } else {
          setApiError(res.data.message || 'Failed to fetch orders');
        }
      })
      .catch(err => {
        setApiError('Failed to fetch orders: ' + (err?.message || err));
        setOrders([]);
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
            {apiError && (
              <CTableRow>
                <CTableDataCell colSpan={6} className="text-danger text-center">
                  {apiError}
                </CTableDataCell>
              </CTableRow>
            )}
            {!apiError && paginatedOrders.length === 0 && (
              <CTableRow>
                <CTableDataCell colSpan={6} className="text-center">
                  No orders found.
                </CTableDataCell>
              </CTableRow>
            )}
            {!apiError && paginatedOrders.map((order, idx) => (
              <CTableRow key={order._id || idx}>
                <CTableDataCell>{order._id}</CTableDataCell>
                <CTableDataCell>{order.user?.email || order.customerName || '-'}</CTableDataCell>
                <CTableDataCell>
                  <div>
                    <table className="table table-sm mb-0">
                      <thead>
                        <tr>
                          <th>Product</th>
                          <th>Size</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {(order.products || []).map((product, pidx) => (
                          <tr key={product.variantId || pidx}>
                            <td>{product.product?.name || '-'}</td>
                            <td>{product.size || '-'}</td>
                            <td>
                              {['super_admin', 'admin', 'product_manager'].includes(userRole) ? (
                                <select
                                  value={product.status || 'Pending'}
                                  onChange={e => handleProductStatusChange(order._id, product.variantId, e.target.value)}
                                  className="form-select form-select-sm"
                                >
                                  <option value="Pending">Pending</option>
                                  <option value="Processing">Processing</option>
                                  <option value="Shipped">Shipped</option>
                                  <option value="Delivered">Delivered</option>
                                  <option value="Cancelled">Cancelled</option>
                                </select>
                              ) : (
                                <span className="badge bg-secondary">{product.status}</span>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </CTableDataCell>
                <CTableDataCell>{order.totalAmount}</CTableDataCell>
                <CTableDataCell>{order.createdAt && new Date(order.createdAt).toLocaleString()}</CTableDataCell>
                {/* View button removed as requested */}
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