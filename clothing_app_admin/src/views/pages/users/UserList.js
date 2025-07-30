/* eslint-disable prettier/prettier */
import { cilPeople, cilTrash } from '@coreui/icons'
import CIcon from '@coreui/icons-react'
import { CRow, CCol, CCard, CCardHeader, CCardBody, CProgress, CTable, CTableHead, CTableRow, CTableHeaderCell, CTableBody, CTableDataCell, CAvatar, CPagination, CPaginationItem, CFormInput } from '@coreui/react'
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

import avatar1 from 'src/assets/images/avatars/1.jpg'
import avatar2 from 'src/assets/images/avatars/2.jpg'
import avatar3 from 'src/assets/images/avatars/3.jpg'
import avatar4 from 'src/assets/images/avatars/4.jpg'
import avatar5 from 'src/assets/images/avatars/5.jpg'
import avatar6 from 'src/assets/images/avatars/6.jpg'

const avatars = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6]

const UserList = () => {
  const [users, setUsers] = useState([])
  const [usersPerPage, setUsersPerPage] = useState(5)
  const [currentPage, setCurrentPage] = useState(1)
  const [search, setSearch] = useState('')
  const navigate = useNavigate()

  useEffect(() => {
    axios.post('http://localhost:3001/api/user/users')
      .then(res => {
        if (res.data.success) {
          setUsers(res.data.data)
        }
      })
      .catch(err => {
        console.error('Failed to fetch users:', err)
      })
  }, [])

  // Search filter
  const filteredUsers = users.filter(
    (user) =>
      (user.name && user.name.toLowerCase().includes(search.toLowerCase())) ||
      (user.phone_number && user.phone_number.toLowerCase().includes(search.toLowerCase())) ||
      (user.email && user.email.toLowerCase().includes(search.toLowerCase()))
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

  // Delete handler (frontend only, for demo)
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
              <span>User Management</span>
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
                    <CTableHeaderCell className="bg-body-tertiary">Name</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary">Phone Number</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary">Email</CTableHeaderCell>
                    <CTableHeaderCell className="bg-body-tertiary text-center">
                      Actions
                    </CTableHeaderCell>
                  </CTableRow>
                </CTableHead>
                <CTableBody>
                  {paginatedUsers.map((user, index) => (
                    <CTableRow
                      key={user._id || index}
                      style={{ cursor: 'pointer' }}
                      onClick={(e) => {
                        if (e.target.closest('.delete-icon')) return
                        navigate(`/users/${user._id}`)
                      }}
                    >
                      <CTableDataCell className="text-center">
                        <CAvatar size="md" src={avatars[index % avatars.length]} />
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{user.name || 'N/A'}</div>
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{user.phone_number || 'N/A'}</div>
                      </CTableDataCell>
                      <CTableDataCell>
                        <div>{user.email || 'N/A'}</div>
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
