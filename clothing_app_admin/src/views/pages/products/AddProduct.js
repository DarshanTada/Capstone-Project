import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel, CRow, CCol, CFormTextarea, CAlert } from '@coreui/react'

const initialProduct = {
  name: '',
  description: '',
  price: '',
  discount_price: '',
  size: '',
  color: '',
  fabric_type: '',
  images: [''],
  category_id: '',
  quantity: '',
  availabe_status: false,
  average_rating: '',
  total_reviews: '',
  gender: '',
  season_objectId: '',
  festival_objectId: '',
  care_instruction_objectId: '',
  sku: '',
  barcode: '',
  is_featured: false,
  is_new_arrival: false,
  is_best_seller: false,
  is_on_sale: false,
  is_on_trend: false,
  weight: '',
  isTryon: false,
  productType: '',
}

const AddProduct = () => {
  const [form, setForm] = useState(initialProduct)
  const [errors, setErrors] = useState({})
  const [showAlert, setShowAlert] = useState(false)
  const navigate = useNavigate()

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setForm((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }))
    setErrors((prev) => ({ ...prev, [name]: undefined }))
  }

  const handleImageChange = (e) => {
    setForm((prev) => ({
      ...prev,
      images: [e.target.value],
    }))
    setErrors((prev) => ({ ...prev, images: undefined }))
  }

  // Validation for important fields
  const validate = () => {
    const newErrors = {}
    if (!form.name.trim()) newErrors.name = 'Product name is required'
    if (!form.price || isNaN(form.price)) newErrors.price = 'Valid price is required'
    if (!form.category_id.trim()) newErrors.category_id = 'Category ID is required'
    if (!form.quantity || isNaN(form.quantity)) newErrors.quantity = 'Valid quantity is required'
    if (!form.images[0] || !form.images[0].trim()) newErrors.images = 'Image URL is required'
    return newErrors
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    const validationErrors = validate()
    if (Object.keys(validationErrors).length > 0) {
      setErrors(validationErrors)
      setShowAlert(true)
      return
    }
    setShowAlert(false)
    // Here you would send form data to your backend API
    alert('Product added!')
    navigate('/products')
  }

  return (
    <CRow className="justify-content-center">
      <CCol md={10}>
        <CCard>
          <CCardHeader>
            <strong>Add Product</strong>
            <CButton color="secondary" className="float-end ms-2" onClick={() => navigate(-1)}>
              Back
            </CButton>
          </CCardHeader>
          <CCardBody>
            {showAlert && (
              <CAlert color="danger" dismissible onClose={() => setShowAlert(false)}>
                Please fill all required fields correctly.
              </CAlert>
            )}
            <CForm onSubmit={handleSubmit} noValidate>
              <CRow className="mb-3">
                <CCol md={12} className="text-center">
                  <img
                    src={
                      form.images[0]
                        ? form.images[0].startsWith('data:')
                          ? form.images[0]
                          : form.images[0]
                        : 'https://via.placeholder.com/120x120?text=Product'
                    }
                    alt="Product"
                    style={{ width: 120, borderRadius: 8 }}
                  />
                  <div className="d-flex flex-column align-items-center mt-2">
                    <CFormLabel className="mb-1">Image URL<span className="text-danger">*</span></CFormLabel>
                    <CFormInput
                      name="image"
                      value={form.images[0]}
                      onChange={handleImageChange}
                      placeholder="Paste image URL or upload below"
                      invalid={!!errors.images}
                      style={{ maxWidth: 350 }}
                    />
                    <span className="my-2">or</span>
                    <input
                      type="file"
                      accept="image/*"
                      onChange={e => {
                        const file = e.target.files[0]
                        if (file) {
                          const reader = new FileReader()
                          reader.onloadend = () => {
                            setForm(prev => ({
                              ...prev,
                              images: [reader.result],
                            }))
                            setErrors(prev => ({ ...prev, images: undefined }))
                          }
                          reader.readAsDataURL(file)
                        }
                      }}
                      className="form-control"
                      style={{ maxWidth: 350 }}
                    />
                    {errors.images && <div className="text-danger small mt-1">{errors.images}</div>}
                  </div>
                </CCol>
              </CRow>
              <CRow className="g-3">
                <CCol md={6}>
                  <CFormLabel>Name<span className="text-danger">*</span></CFormLabel>
                  <CFormInput
                    name="name"
                    value={form.name}
                    onChange={handleChange}
                    invalid={!!errors.name}
                  />
                  {errors.name && <div className="text-danger small">{errors.name}</div>}

                  <CFormLabel className="mt-2">Description</CFormLabel>
                  <CFormTextarea name="description" value={form.description} onChange={handleChange} />

                  <CFormLabel className="mt-2">Price<span className="text-danger">*</span></CFormLabel>
                  <CFormInput
                    name="price"
                    type="number"
                    value={form.price}
                    onChange={handleChange}
                    invalid={!!errors.price}
                  />
                  {errors.price && <div className="text-danger small">{errors.price}</div>}

                  <CFormLabel className="mt-2">Discount Price</CFormLabel>
                  <CFormInput name="discount_price" type="number" value={form.discount_price} onChange={handleChange} />

                  <CFormLabel className="mt-2">Size</CFormLabel>
                  <CFormInput name="size" value={form.size} onChange={handleChange} />

                  <CFormLabel className="mt-2">Color</CFormLabel>
                  <CFormInput name="color" value={form.color} onChange={handleChange} />

                  <CFormLabel className="mt-2">Fabric Type</CFormLabel>
                  <CFormInput name="fabric_type" value={form.fabric_type} onChange={handleChange} />

                  <CFormLabel className="mt-2">Category ID<span className="text-danger">*</span></CFormLabel>
                  <CFormInput
                    name="category_id"
                    value={form.category_id}
                    onChange={handleChange}
                    invalid={!!errors.category_id}
                  />
                  {errors.category_id && <div className="text-danger small">{errors.category_id}</div>}

                  <CFormLabel className="mt-2">Quantity<span className="text-danger">*</span></CFormLabel>
                  <CFormInput
                    name="quantity"
                    type="number"
                    value={form.quantity}
                    onChange={handleChange}
                    invalid={!!errors.quantity}
                  />
                  {errors.quantity && <div className="text-danger small">{errors.quantity}</div>}

                  <CFormLabel className="mt-2">Available Status</CFormLabel>
                  <div className="d-flex align-items-center mb-2">
                    <input
                      type="checkbox"
                      name="availabe_status"
                      checked={form.availabe_status}
                      onChange={handleChange}
                      className="me-2"
                    />
                    <span className="ms-2">{form.availabe_status ? 'Available' : 'Not Available'}</span>
                  </div>
                  <CFormLabel className="mt-2">Average Rating</CFormLabel>
                  <CFormInput name="average_rating" type="number" value={form.average_rating} onChange={handleChange} />                 
                </CCol>
                <CCol md={6}>
                 
                  <CFormLabel className="mt-2">Total Reviews</CFormLabel>
                  <CFormInput name="total_reviews" type="number" value={form.total_reviews} onChange={handleChange} />

                  <CFormLabel className="mt-2">Gender</CFormLabel>
                  <CFormInput name="gender" value={form.gender} onChange={handleChange} />
                  <CFormLabel>Season ObjectId</CFormLabel>
                  <CFormInput name="season_objectId" value={form.season_objectId} onChange={handleChange} />

                  <CFormLabel className="mt-2">Festival ObjectId</CFormLabel>
                  <CFormInput name="festival_objectId" value={form.festival_objectId} onChange={handleChange} />

                  <CFormLabel className="mt-2">Care Instruction ObjectId</CFormLabel>
                  <CFormInput name="care_instruction_objectId" value={form.care_instruction_objectId} onChange={handleChange} />

                  <CFormLabel className="mt-2">SKU</CFormLabel>
                  <CFormInput name="sku" value={form.sku} onChange={handleChange} />

                  <CFormLabel className="mt-2">Barcode</CFormLabel>
                  <CFormInput name="barcode" value={form.barcode} onChange={handleChange} />

                  <CFormLabel className="mt-2">Weight</CFormLabel>
                  <CFormInput name="weight" value={form.weight} onChange={handleChange} />

                  <CFormLabel className="mt-2">Product Type</CFormLabel>
                  <CFormInput name="productType" value={form.productType} onChange={handleChange} />

                  <div className="mt-2 d-flex flex-wrap gap-3">
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_featured"
                        checked={form.is_featured}
                        onChange={handleChange}
                        className="me-1"
                      /> Featured
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_new_arrival"
                        checked={form.is_new_arrival}
                        onChange={handleChange}
                        className="me-1"
                      /> New Arrival
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_best_seller"
                        checked={form.is_best_seller}
                        onChange={handleChange}
                        className="me-1"
                      /> Best Seller
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_on_sale"
                        checked={form.is_on_sale}
                        onChange={handleChange}
                        className="me-1"
                      /> On Sale
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_on_trend"
                        checked={form.is_on_trend}
                        onChange={handleChange}
                        className="me-1"
                      /> On Trend
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="isTryon"
                        checked={form.isTryon}
                        onChange={handleChange}
                        className="me-1"
                      /> Try On
                    </label>
                  </div>
                </CCol>
              </CRow>
              <CRow>
                <CCol className="d-flex justify-content-center">
                  <CButton className="my-3" color="primary" type="submit">
                    Add Product
                  </CButton>
                </CCol>
              </CRow>
            </CForm>
          </CCardBody>
        </CCard>
      </CCol>
    </CRow>
  )
}

export default AddProduct