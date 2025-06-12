/* eslint-disable prettier/prettier */
import { cilPeople, cilTrash } from '@coreui/icons'
import CIcon from '@coreui/icons-react'
import { CRow, CCol, CCard, CCardHeader, CCardBody, CProgress, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell, CAvatar, CPagination, CPaginationItem, CBadge, CFormInput } from '@coreui/react'
import React, { useState } from 'react'
import { cifUs, cifBr, cifIn, cifFr, cifEs, cifPl } from '@coreui/icons'
import { cibCcMastercard, cibCcVisa, cibCcStripe, cibCcPaypal, cibCcApplePay, cibCcAmex } from '@coreui/icons'
import { useNavigate } from 'react-router-dom'


import avatar1 from 'src/assets/images/avatars/1.jpg'
import avatar2 from 'src/assets/images/avatars/2.jpg'
import avatar3 from 'src/assets/images/avatars/3.jpg'
import avatar4 from 'src/assets/images/avatars/4.jpg'
import avatar5 from 'src/assets/images/avatars/5.jpg'
import avatar6 from 'src/assets/images/avatars/6.jpg'


const UserList = () => { 
  // Example: Add phone_number and email to each user in tableExample
const tableExample = [
  {
    avatar: { src: avatar1, status: 'success' },
    user: {
      name: 'Yiorgos Avraamu',
      phone_number: '+1 555-123-4567',
      email: 'yiorgos@example.com',
      new: true,
      registered: 'Jan 1, 2023',
    },
    country: { name: 'USA', flag: cifUs },
    usage: {
      value: 50,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'success',
    },
    payment: { name: 'Mastercard', icon: cibCcMastercard },
    activity: '10 sec ago',
  },
  {
    avatar: { src: avatar2, status: 'danger' },
    user: {
      name: 'Avram Tarasios',
      phone_number: '+55 11 91234-5678',
      email: 'avram@example.com',
      new: false,
      registered: 'Jan 1, 2023',
    },
    country: { name: 'Brazil', flag: cifBr },
    usage: {
      value: 22,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'info',
    },
    payment: { name: 'Visa', icon: cibCcVisa },
    activity: '5 minutes ago',
  },
  {
    avatar: { src: avatar3, status: 'warning' },
    user: { 
      name: 'Quintin Ed', 
      phone_number: '+91 98765 43210', 
      email: 'quintin@example.com', 
      new: true, 
      registered: 'Jan 1, 2023' 
    },
    country: { name: 'India', flag: cifIn },
    usage: {
      value: 74,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'warning',
    },
    payment: { name: 'Stripe', icon: cibCcStripe },
    activity: '1 hour ago',
  },
  {
    avatar: { src: avatar4, status: 'secondary' },
    user: { 
      name: 'Enéas Kwadwo', 
      phone_number: '+33 1 23 45 67 89', 
      email: 'eneas@example.com', 
      new: true, 
      registered: 'Jan 1, 2023' 
    },
    country: { name: 'France', flag: cifFr },
    usage: {
      value: 98,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'danger',
    },
    payment: { name: 'PayPal', icon: cibCcPaypal },
    activity: 'Last month',
  },
  {
    avatar: { src: avatar5, status: 'success' },
    user: {
      name: 'Agapetus Tadeáš',
      phone_number: '+34 612 34 56 78',
      email: 'agapetus@example.com',
      new: true,
      registered: 'Jan 1, 2023',
    },
    country: { name: 'Spain', flag: cifEs },
    usage: {
      value: 22,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'primary',
    },
    payment: { name: 'Google Wallet', icon: cibCcApplePay },
    activity: 'Last week',
  },
  {
    avatar: { src: avatar6, status: 'danger' },
    user: {
      name: 'Friderik Dávid',
      phone_number: '+48 12 345 67 89',
      email: 'friderik@example.com',
      new: true,
      registered: 'Jan 1, 2023',
    },
    country: { name: 'Poland', flag: cifPl },
    usage: {
      value: 43,
      period: 'Jun 11, 2023 - Jul 10, 2023',
      color: 'success',
    },
    payment: { name: 'Amex', icon: cibCcAmex },
    activity: 'Last week',
  },
]

  const progressGroupExample2 = [
    { title: 'Male', icon: cilPeople, value: 35 },
    { title: 'Female', icon: cilPeople, value: 47 },
    { title: 'Other', icon: cilPeople, value: 18 },
  ]

  const [usersPerPage, setUsersPerPage] = useState(2)
  const [currentPage, setCurrentPage] = useState(1)
  const [users, setUsers] = useState(tableExample)
  const [search, setSearch] = useState('')

  // Search filter
  const filteredUsers = users.filter(
    (item) =>
      item.user.name.toLowerCase().includes(search.toLowerCase()) ||
      item.user.phone_number.toLowerCase().includes(search.toLowerCase()) ||
      item.user.email.toLowerCase().includes(search.toLowerCase())
  )

  const totalPages = Math.ceil(filteredUsers.length / usersPerPage)

  const handlePageChange = (page) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page)
    }
  }

  const handleUsersPerPageChange = (e) => {
    setUsersPerPage(Number(e.target.value))
    setCurrentPage(1)
  }

  const handleSearchChange = (e) => {
    setSearch(e.target.value)
    setCurrentPage(1)
  }

  const paginatedUsers = filteredUsers.slice(
    (currentPage - 1) * usersPerPage,
    currentPage * usersPerPage
  )

  const navigate = useNavigate()

  // Delete handler
  const handleDelete = (deleteIdx) => {
    if (window.confirm('Are you sure you want to delete this user?')) {
      const globalIdx = (currentPage - 1) * usersPerPage + deleteIdx
      setUsers((prev) => prev.filter((_, idx) => idx !== globalIdx))
    }
  }

  const pageOptions = [2, 3, 5, 10, 15, 20, 25, 50].filter(num => num < users.length)
  if (users.length > 0) pageOptions.push(users.length)

  return (
    <div>
      <CRow>
        <CCol xs>
          <CCard className="mb-4">
            <CCardHeader className="d-flex justify-content-between align-items-center">
              <span>Traffic {' & '} Sales</span>
              <div>
                <label htmlFor="usersPerPage" className="me-2">Users per page:</label>
                <select
                  id="usersPerPage"
                  value={usersPerPage}
                  onChange={handleUsersPerPageChange}
                  className="form-select d-inline-block w-auto"
                >
                  {pageOptions.map((num) => (
                    <option key={num} value={num}>
                      {num === users.length ? 'All' : num}
                    </option>
                  ))}
                </select>
              </div>
            </CCardHeader>
            <CCardBody>
              <CRow>
                <CCol xs={12}>
                  <CRow>
                    <CCol xs={3}>
                      <div className="border-start border-start-4 border-start-info py-1 px-3">
                        <div className="text-body-secondary text-truncate small">New Users</div>
                        <div className="fs-5 fw-semibold">9,123</div>
                      </div>
                    </CCol>
                    <CCol xs={3}>
                      <div className="border-start border-start-4 border-start-danger py-1 px-3 mb-3">
                        <div className="text-body-secondary text-truncate small">
                          Recurring Users
                        </div>
                        <div className="fs-5 fw-semibold">22,643</div>
                      </div>
                    </CCol>
                    <CCol xs={3}>
                      <div className="border-start border-start-4 border-start-warning py-1 px-3 mb-3">
                        <div className="text-body-secondary text-truncate small">Pageviews</div>
                        <div className="fs-5 fw-semibold">78,623</div>
                      </div>
                    </CCol>
                    <CCol xs={3}>
                      <div className="border-start border-start-4 border-start-success py-1 px-3 mb-3">
                        <div className="text-body-secondary text-truncate small">Organic</div>
                        <div className="fs-5 fw-semibold">49,123</div>
                      </div>
                    </CCol>
                    <hr className="mt-0" />
                      {progressGroupExample2.map((item, index) => (
                    <CCol xs={12} md={4}>
                        <div className="progress-group mb-4" key={index}>
                          <div className="progress-group-header">
                            <CIcon className="me-2" icon={item.icon} size="lg" />
                            <span>{item.title}</span>
                            <span className="ms-auto fw-semibold">{item.value}%</span>
                          </div>
                          <div className="progress-group-bars">
                            <CProgress thin color="warning" value={item.value} />
                          </div>
                        </div>
                      <div className="mb-5"></div>
                    </CCol>
                      ))}
                  </CRow>
                </CCol>
              </CRow>

              <br />
              
              <div className="mb-3 d-flex justify-content-end">
                <CFormInput
                  type="text"
                  placeholder="Search by name, phone, or email"
                  value={search}
                  onChange={handleSearchChange}
                  style={{ maxWidth: 300 }}
                />
              </div>
              <CTable align="middle" className="mb-0 border" hover responsive>
                <CTableHead className="text-nowrap">
                  <CTableRow>
                    <CTableHeaderCell className="bg-body-tertiary text-center">
                      <CIcon icon={cilPeople} />
                    </CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary">User</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary">Phone Number</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary">Email</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary text-center"> {/* Add Delete column */}
                      Actions
                    </CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {paginatedUsers.map((item, index) => (
                    <CTableRow
                      key={index + (currentPage - 1) * usersPerPage}
                      style={{ cursor: 'pointer' }}
                      onClick={(e) => {
                        // Prevent row click when clicking delete
                        if (e.target.closest('.delete-icon')) return
                        navigate(`/users/${index + (currentPage - 1) * usersPerPage}`)
                      }}
                    >
                      <CTableDataCell className="text-center">
                        <CAvatar size="md" src={item.avatar.src} />
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{item.user.name}</div>
                        <div className="small text-body-secondary text-nowrap">
                          <span>{item.user.new ? 'New' : 'Recurring'}</span> | Registered: {item.user.registered}
                        </div>
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{item.user.phone_number}</div>
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{item.user.email}</div>
                      </CTableDataCell>
                      <CTableDataCell className="text-center">
                        <CIcon
                          icon={cilTrash}
                          className="text-danger delete-icon"
                          style={{ cursor: 'pointer' }}
                          title="Delete"
                          onClick={() => handleDelete(index)}
                        />
                      </CTableDataCell>
                    </CTableRow>
                  ))}
                </CTableBody>
              </CTable>
              <CPagination className="justify-content-center my-3" aria-label="Page navigation example">
                <CPaginationItem
                  disabled={currentPage === 1}
                  onClick={() => handlePageChange(currentPage - 1)}
                >
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
                <CPaginationItem
                  disabled={currentPage === totalPages}
                  onClick={() => handlePageChange(currentPage + 1)}
                >
                  Next
                </CPaginationItem>
              </CPagination>
            </CCardBody>
          </CCard>
        </CCol>
      </CRow>
    </div> 
  )
}

export default UserList
