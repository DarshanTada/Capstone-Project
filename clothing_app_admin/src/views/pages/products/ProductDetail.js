import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel, CRow, CCol, CFormTextarea } from '@coreui/react'
import tshirtImg from 'src/assets/images/products/T-Shirt.png'

const dummyProduct = {
  objectId: '1',
  name: 'Classic T-Shirt',
  description: 'A comfortable cotton t-shirt.',
  price: 19.99,
  discount_price: 14.99,
  size: 'M',
  color: 'Blue',
  fabric_type: 'Cotton',
  images: [tshirtImg],
  category_id: 'tops',
  quantity: 120,
  availabe_status: true,
  average_rating: 4.5,
  total_reviews: 12,
  gender: 'Unisex',
  season_objectId: 'summer',
  festival_objectId: 'eid',
  care_instruction_objectId: 'machine_wash',
  sku: 'TSHIRT-001',
  barcode: '1234567890123',
  is_featured: true,
  is_new_arrival: false,
  is_best_seller: true,
  is_on_sale: true,
  is_on_trend: false,
  weight: '200g',
  isTryon: false,
  productType: 'Apparel',
}

const ProductDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  // In real app, fetch product by id
  const [form, setForm] = useState(dummyProduct)
  const [isEditing, setIsEditing] = useState(false)

  useEffect(() => {
    // Fetch product by id here if using API
    setForm(dummyProduct)
    setIsEditing(false)
  }, [id])

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setForm((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }))
  }

  const handleImageChange = (e) => {
    setForm((prev) => ({
      ...prev,
      images: [e.target.value],
    }))
  }

  const handleSave = (e) => {
    e.preventDefault()
    setIsEditing(false)
    // Save logic here (API call)
    alert('Product details saved!')
  }

  if (!form) return <div>Product not found</div>

  return (
    <CRow className="justify-content-center mb-4">
      <CCol md={10}>
        <CCard>
          <CCardHeader>
            <strong>Product Details</strong>
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
                  <img src={form.images[0]} alt="Product" style={{ width: 120, borderRadius: 8 }} />
                  {isEditing && (
                    <>
                      <CFormLabel className="mt-2">Image URL</CFormLabel>
                      <CFormInput name="image" value={form.images[0]} onChange={handleImageChange} />
                    </>
                  )}
                </CCol>
              </CRow>
              <CRow className="g-3">
                <CCol md={6}>
                  <CFormLabel>Name</CFormLabel>
                  <CFormInput name="name" value={form.name} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Description</CFormLabel>
                  <CFormTextarea name="description" value={form.description} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Price</CFormLabel>
                  <CFormInput name="price" type="number" value={form.price} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Discount Price</CFormLabel>
                  <CFormInput name="discount_price" type="number" value={form.discount_price} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Size</CFormLabel>
                  <CFormInput name="size" value={form.size} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Color</CFormLabel>
                  <CFormInput name="color" value={form.color} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Fabric Type</CFormLabel>
                  <CFormInput name="fabric_type" value={form.fabric_type} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Category ID</CFormLabel>
                  <CFormInput name="category_id" value={form.category_id} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Quantity</CFormLabel>
                  <CFormInput name="quantity" type="number" value={form.quantity} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Available Status</CFormLabel>
                  <div className="d-flex align-items-center mb-2">
                    <input
                      type="checkbox"
                      name="availabe_status"
                      checked={form.availabe_status}
                      onChange={handleChange}
                      disabled={!isEditing}
                      className="me-2"
                    />
                    <span className="ms-2">{form.availabe_status ? 'Available' : 'Not Available'}</span>
                  </div>
                  <CFormLabel className="mt-2">Average Rating</CFormLabel>
                  <CFormInput name="average_rating" type="number" value={form.average_rating} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Total Reviews</CFormLabel>
                  <CFormInput name="total_reviews" type="number" value={form.total_reviews} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Gender</CFormLabel>
                  <CFormInput name="gender" value={form.gender} onChange={handleChange} disabled={!isEditing} />
                </CCol>
                <CCol md={6}>
                  <CFormLabel>Season ObjectId</CFormLabel>
                  <CFormInput name="season_objectId" value={form.season_objectId} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Festival ObjectId</CFormLabel>
                  <CFormInput name="festival_objectId" value={form.festival_objectId} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Care Instruction ObjectId</CFormLabel>
                  <CFormInput name="care_instruction_objectId" value={form.care_instruction_objectId} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">SKU</CFormLabel>
                  <CFormInput name="sku" value={form.sku} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Barcode</CFormLabel>
                  <CFormInput name="barcode" value={form.barcode} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Weight</CFormLabel>
                  <CFormInput name="weight" value={form.weight} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Product Type</CFormLabel>
                  <CFormInput name="productType" value={form.productType} onChange={handleChange} disabled={!isEditing} />
                  <div className="mt-2 d-flex flex-wrap gap-3">
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_featured"
                        checked={form.is_featured}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> Featured
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_new_arrival"
                        checked={form.is_new_arrival}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> New Arrival
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_best_seller"
                        checked={form.is_best_seller}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> Best Seller
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_on_sale"
                        checked={form.is_on_sale}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> On Sale
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="is_on_trend"
                        checked={form.is_on_trend}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> On Trend
                    </label>
                    <label className="mb-0">
                      <input
                        type="checkbox"
                        name="isTryon"
                        checked={form.isTryon}
                        onChange={handleChange}
                        disabled={!isEditing}
                        className="me-1"
                      /> Try On
                    </label>
                  </div>
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

export default ProductDetail