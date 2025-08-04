import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel, CRow, CCol } from '@coreui/react'
import axios from 'axios'
import GLBViewer from 'src/components/GLBViewer'
import PromotionalEmailForm from './PromotionalEmailForm'

const UserDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const [form, setForm] = useState(null)
  const [isEditing, setIsEditing] = useState(false)

  useEffect(() => {
    if (id) {
      axios.post('http://localhost:3001/api/user/userById', { userId: id })
        .then(res => {
          console.log('UserDetail API response:', res.data);
          if (res.data.success) {
            // If response is { user, preference, ... }, flatten for form
            const data = res.data.data;
            if (data && typeof data === 'object' && (data.user || data.preference)) {
              const processed = {
                ...data.user,
                preference: data.preference || {},
                relationProfile: data.relationProfile || [],
              };
              console.log('Processed user detail:', processed);
              setForm(processed);
            } else {
              console.log('Processed user detail (raw):', data);
              setForm(data);
            }
          } else {
            setForm(null)
          }
        })
        .catch((err) => {
          console.error('UserDetail API error:', err);
          setForm(null)
        })
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
            {/* Promotional Email Section */}
            {form.email && (
              <div className="mb-4 p-3 border rounded">
                <h5>Send Promotional Email</h5>
                <PromotionalEmailForm userEmail={form.email} />
              </div>
            )}
            <CForm onSubmit={handleSave}>
              <CRow className="mb-3">
                <CCol md={12} className="text-center">
                  {/* Show avatar image if available */}
                  {form.preference?.avartarURL && (
                    <img src={form.preference.avartarURL} alt="Avatar" style={{ width: 120, borderRadius: '50%' }} />
                  )}
                  {/* Show avatar GLB if available */}
                  {form.preference?.avatarGLBURL && (
                    <div style={{ marginTop: 16 }}>
                      <GLBViewer url={form.preference.avatarGLBURL} width={300} height={300} />
                    </div>
                  )}
                </CCol>
              </CRow>
              <CRow className="g-3">
                <CCol md={6}>
                  <CFormLabel>Username</CFormLabel>
                  <CFormInput name="username" value={form.preference?.username || ''} disabled />
                  <CFormLabel className="mt-2">Phone Number</CFormLabel>
                  <CFormInput name="phone_number" value={form.phone_number || ''} disabled />
                  <CFormLabel className="mt-2">Email</CFormLabel>
                  <CFormInput name="email" value={form.email || ''} disabled />
                  <CFormLabel className="mt-2">Role</CFormLabel>
                  <CFormInput name="role" value={form.role || ''} disabled />
                  <CFormLabel className="mt-2">Gender</CFormLabel>
                  <CFormInput name="gender" value={form.preference?.gender || ''} disabled />
                  <CFormLabel className="mt-2">Age</CFormLabel>
                  <CFormInput name="age" value={form.preference?.age || ''} disabled />
                  <CFormLabel className="mt-2">Body Type</CFormLabel>
                  <CFormInput name="body_type" value={form.preference?.body_type || ''} disabled />
                  <CFormLabel className="mt-2">Height</CFormLabel>
                  <CFormInput name="height" value={form.preference?.height || ''} disabled />
                  <CFormLabel className="mt-2">Skin Tone</CFormLabel>
                  <CFormInput name="skin_tone" value={form.preference?.skin_tone || ''} disabled />
                  <CFormLabel className="mt-2">Undertone</CFormLabel>
                  <CFormInput name="undertone" value={form.preference?.undertone || ''} disabled />
                </CCol>
                <CCol md={6}>
                  <CFormLabel>Style</CFormLabel>
                  <CFormInput name="style" value={Array.isArray(form.preference?.style) ? form.preference.style.join(', ') : ''} disabled />
                  <CFormLabel className="mt-2">Occasion</CFormLabel>
                  <CFormInput name="occasion" value={Array.isArray(form.preference?.occasion) ? form.preference.occasion.join(', ') : ''} disabled />
                  <CFormLabel className="mt-2">Festivals</CFormLabel>
                  <CFormInput name="festivals" value={Array.isArray(form.preference?.festivals) ? form.preference.festivals.join(', ') : ''} disabled />
                  <CFormLabel className="mt-2">Color Tones</CFormLabel>
                  <CFormInput name="color_tones" value={Array.isArray(form.preference?.color_tones) ? form.preference.color_tones.join(', ') : ''} disabled />
                  <CFormLabel className="mt-2">Size</CFormLabel>
                  <CFormInput name="size" value={form.preference?.size || ''} disabled />
                  <CFormLabel className="mt-2">Relation Profile</CFormLabel>
                  <CFormInput name="relationProfile" value={Array.isArray(form.relationProfile) ? form.relationProfile.join(', ') : ''} disabled />
                </CCol>
              </CRow>
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default UserDetail