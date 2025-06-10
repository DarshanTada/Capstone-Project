import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel, CRow, CCol } from '@coreui/react'
import avatar1 from 'src/assets/images/avatars/1.jpg'
import avatar2 from 'src/assets/images/avatars/2.jpg'
import avatar3 from 'src/assets/images/avatars/3.jpg'
import avatar4 from 'src/assets/images/avatars/4.jpg'
import avatar5 from 'src/assets/images/avatars/5.jpg'
import avatar6 from 'src/assets/images/avatars/6.jpg'

const avatars = [avatar1, avatar2, avatar3, avatar4, avatar5, avatar6]

// Dummy users from UserList.js
const users = [
  {
    name: 'Yiorgos Avraamu',
    phone_number: '+1 555-123-4567',
    email: 'yiorgos@example.com',
    gender: 'Male',
    age: 28,
    festival: 'Christmas',
    body_type: 'Athletic',
    height: '180cm',
    color_palette: 'Winter',
    relation: 'Self',
    photo: avatar1,
    size: 'M',
    role: 'User',
    address: '123 Main St, City, Country',
  },
  {
    name: 'Avram Tarasios',
    phone_number: '+55 11 91234-5678',
    email: 'avram@example.com',
    gender: 'Male',
    age: 32,
    festival: 'Easter',
    body_type: 'Slim',
    height: '175cm',
    color_palette: 'Summer',
    relation: 'Self',
    photo: avatar2,
    size: 'L',
    role: 'Admin',
    address: '456 Another St, City, Country',
  },
  {
    name: 'Quintin Ed',
    phone_number: '+91 98765 43210',
    email: 'quintin@example.com',
    gender: 'Male',
    age: 25,
    festival: 'Diwali',
    body_type: 'Average',
    height: '178cm',
    color_palette: 'Spring',
    relation: 'Friend',
    photo: avatar3,
    size: 'M',
    role: 'User',
    address: '789 Some Rd, City, Country',
  },
  {
    name: 'Enéas Kwadwo',
    phone_number: '+33 1 23 45 67 89',
    email: 'eneas@example.com',
    gender: 'Male',
    age: 30,
    festival: 'Bastille Day',
    body_type: 'Slim',
    height: '172cm',
    color_palette: 'Autumn',
    relation: 'Colleague',
    photo: avatar4,
    size: 'S',
    role: 'User',
    address: '101 Rue Example, Paris, France',
  },
  {
    name: 'Agapetus Tadeáš',
    phone_number: '+34 612 34 56 78',
    email: 'agapetus@example.com',
    gender: 'Male',
    age: 27,
    festival: 'La Tomatina',
    body_type: 'Athletic',
    height: '182cm',
    color_palette: 'Winter',
    relation: 'Family',
    photo: avatar5,
    size: 'L',
    role: 'User',
    address: '202 Fiesta St, Madrid, Spain',
  },
  {
    name: 'Friderik Dávid',
    phone_number: '+48 12 345 67 89',
    email: 'friderik@example.com',
    gender: 'Male',
    age: 29,
    festival: 'Easter',
    body_type: 'Average',
    height: '176cm',
    color_palette: 'Summer',
    relation: 'Self',
    photo: avatar6,
    size: 'M',
    role: 'User',
    address: '303 Spring Ave, Warsaw, Poland',
  },
]

const UserDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const userIndex = parseInt(id, 10)
  const [form, setForm] = useState(users[userIndex] || {})
  const [isEditing, setIsEditing] = useState(false)

  useEffect(() => {
    setForm(users[userIndex] || {})
    setIsEditing(false)
  }, [userIndex])

  const handleChange = (e) => {
    const { name, value } = e.target
    setForm((prev) => ({ ...prev, [name]: value }))
  }

  const handlePhotoChange = (e) => {
    setForm((prev) => ({ ...prev, photo: avatars[e.target.value] }))
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
                  <img src={form.photo} alt="User" style={{ width: 120, borderRadius: '50%' }} />
                  {/* Uncomment below if you want to allow photo change */}
                  {/* {isEditing && (
                    <>
                      <CFormLabel className="mt-2">Photo</CFormLabel>
                      <select className="form-select" value={avatars.indexOf(form.photo)} onChange={handlePhotoChange}>
                        {avatars.map((a, idx) => (
                          <option key={idx} value={idx}>Avatar {idx + 1}</option>
                        ))}
                      </select>
                    </>
                  )} */}
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
                  <CFormLabel className="mt-2">Festival</CFormLabel>
                  <CFormInput name="festival" value={form.festival || ''} onChange={handleChange} disabled={!isEditing} />
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