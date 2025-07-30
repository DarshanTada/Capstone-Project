import React, { useEffect, useState } from 'react';
import { CCard, CCardBody, CCardHeader, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell, CPagination, CPaginationItem, CButton, CFormInput } from '@coreui/react';
import { useNavigate } from 'react-router-dom';

const OrderList = () => {
  // ...existing state and logic...
  const [orders, setOrders] = useState([]);
  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [ordersPerPage, setOrdersPerPage] = useState(10);
  const [apiError, setApiError] = useState('');
  const userRole = localStorage.getItem('userRole') || 'user';
  const loggedInUserId = localStorage.getItem('userId');

  useEffect(() => {
    // Fetch orders from backend
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      const res = await fetch('http://localhost:3001/api/order/getAllOrders', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ page: 1, limit: 100 }),
      });
      const data = await res.json();
      if (data.success) {
        setOrders(data.data || []);
        setApiError('');
      } else {
        setApiError(data.message || 'Failed to fetch orders');
      }
    } catch (err) {
      setApiError('Failed to fetch orders: ' + (err?.message || err));
      setOrders([]);
    }
  };

  const filteredOrders = orders.filter(order =>
    (order.customerName && order.customerName.toLowerCase().includes(search.toLowerCase())) ||
    (order._id && order._id.toLowerCase().includes(search.toLowerCase()))
  );

  const totalPages = Math.ceil(filteredOrders.length / ordersPerPage);
  const paginatedOrders = filteredOrders.slice(
    (currentPage - 1) * ordersPerPage,
    currentPage * ordersPerPage
  );

  const handlePageChange = (page) => {
    if (page >= 1 && page <= totalPages) setCurrentPage(page);
  };

  const handleSearchChange = (e) => {
    setSearch(e.target.value);
    setCurrentPage(1);
  };

  const handleOrdersPerPageChange = (e) => {
    setOrdersPerPage(Number(e.target.value));
    setCurrentPage(1);
  };

  const pageOptions = [2, 3, 5, 10, 15, 20, 25, 50].filter(num => num < filteredOrders.length);
  if (filteredOrders.length > 0) pageOptions.push(filteredOrders.length);

  // Update product status for a product in an order
  const handleProductStatusChange = async (orderId, variantId, newStatus) => {
    try {
      // Set reason based on status
      let reason = '';
      if (newStatus === 'Shipped') reason = 'Package dispatched via FedEx';
      else if (newStatus === 'Delivered') reason = 'Order delivered to customer';
      else if (newStatus === 'Processing') reason = 'Order is being processed';
      else if (newStatus === 'Pending') reason = 'Order is pending';
      else if (newStatus === 'Cancelled') reason = 'Order cancelled by user';

      console.log({ orderId, variantId, status: newStatus, reason }); // Debug: show payload
      const res = await fetch('http://localhost:3001/api/order/updateProductStatus', {
        method: 'POST', // Use POST to match backend
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ orderId, variantId, status: newStatus, reason }),
      });
      const data = await res.json();
      if (data.success) {
        fetchOrders(); // Refresh orders
      } else {
        alert(data.message || 'Failed to update product status');
      }
    } catch (err) {
      alert('Failed to update product status: ' + (err?.message || err));
    }
  };

  // Product status options from backend enum
  const productStatusOptions = [
    { value: 'Pending', label: 'Pending' },
    { value: 'Processing', label: 'Processing' },
    { value: 'Shipped', label: 'Shipped' },
    { value: 'Delivered', label: 'Delivered' },
    { value: 'Cancelled', label: 'Cancelled' },
  ];

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
              {/* Removed Actions column */}
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
                          <tr key={product.variantId}>
                            <td>{product.product?.name || '-'}</td>
                            <td>{product.size || '-'}</td>
                            <td>
                              {(() => {
                                const isOwnOrder = loggedInUserId && order.user && (String(order.user._id) === String(loggedInUserId) || String(order.user) === String(loggedInUserId));
                                return (
                                  <select
                                    value={product.status || "Pending"}
                                    onChange={e => handleProductStatusChange(
                                      order._id,
                                      product.variantId,
                                      e.target.value

                                    )}
                                    className="form-select form-select-sm"
                                  >
                                    {productStatusOptions.map(opt => (
                                      <option key={opt.value} value={opt.value}>{opt.label}</option>
                                    ))}
                                  </select>
                                );
                              })()}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </CTableDataCell>
                <CTableDataCell>{order.totalAmount}</CTableDataCell>
                <CTableDataCell>{order.createdAt && new Date(order.createdAt).toLocaleString()}</CTableDataCell>
                {/* Removed Actions column */}
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
  );
};

export default OrderList;