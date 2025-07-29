import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel, CRow, CCol } from '@coreui/react'
import axios from 'axios'

const UserDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const [form, setForm] = useState(null)
  const [isEditing, setIsEditing] = useState(false)

  useEffect(() => {
    if (id) {
      axios.post('http://localhost:3001/api/user/user', { userId: id })
        .then(res => {
          if (res.data.success) {
            setForm(res.data.data)
          } else {
            setForm(null)
          }
        })
        .catch(() => setForm(null))
    }
    setIsEditing(false)
  }, [id])

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm((prev) => ({ ...prev, [name]: value }))
  }

  const handleSave = (e) => {
    e.preventDefault()
    setIsEditing(false)
    // Save logic here (API call or context update)
    alert('User details saved!')
  }

  if (!form) return <div>User not found</div>

  return (
    <CRow className="justify-content-center">
      <CCol md={11} className='mb-4'>
        <CCard>
          <CCardHeader>
            <strong>User Details</strong>
            <CButton color="secondary" className="float-end ms-2" onClick={() => navigate(-1)}>
              Back
            </CButton>
            {!isEditing && (
              <CButton color="primary" className="float-end" onClick={() => setIsEditing(true)}>
                Edit
              </CButton>
            )}
          </CCardHeader>
          <CCardBody>
            <CForm onSubmit={handleSave}>
              <CRow className="mb-3">
                <CCol md={12} className="text-center">
                  {/* Show photo if available */}
                  {form?.photo_url && (
                    <img src={`http://localhost:3001/${form.photo_url}`} alt="User" style={{ width: 120, borderRadius: '50%' }} />
                  )}
                </CCol>
              </CRow>
              <CRow className="g-3">
                <CCol md={6}>
                  <CFormLabel>Name</CFormLabel>
                  <CFormInput name="name" value={form.name || ''} onChange={handleChange} required disabled={!isEditing} />
                  <CFormLabel className="mt-2">Phone Number</CFormLabel>
                  <CFormInput name="phone_number" value={form.phone_number || ''} onChange={handleChange} required disabled={!isEditing} />
                  <CFormLabel className="mt-2">Email</CFormLabel>
                  <CFormInput name="email" value={form.email || ''} onChange={handleChange} required disabled={!isEditing} />
                  <CFormLabel className="mt-2">Gender</CFormLabel>
                  <CFormInput name="gender" value={form.gender || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Age</CFormLabel>
                  <CFormInput name="age" value={form.age || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Body Type</CFormLabel>
                  <CFormInput name="body_type" value={form.body_type || ''} onChange={handleChange} disabled={!isEditing} />
                </CCol>
                <CCol md={6}>
                  <CFormLabel>Height</CFormLabel>
                  <CFormInput name="height" value={form.height || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Color Palette</CFormLabel>
                  <CFormInput name="color_palette" value={form.color_palette || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Relation</CFormLabel>
                  <CFormInput name="relation" value={form.relation || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Size</CFormLabel>
                  <CFormInput name="size" value={form.size || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Role</CFormLabel>
                  <CFormInput name="role" value={form.role || ''} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Address</CFormLabel>
                  <CFormInput name="address" value={form.address || ''} onChange={handleChange} disabled={!isEditing} />
                </CCol>
              </CRow>
              {isEditing && (
                <CRow>
                  <CCol className="d-flex justify-content-center">
                    <CButton className="my-3" color="primary" type="submit">
                      Save
                    </CButton>
                  </CCol>
                </CRow>
              )}
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default UserDetail