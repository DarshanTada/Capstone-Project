import React, { useState } from 'react'
import {
  CCard, CCardBody, CCardHeader, CForm, CFormInput, CButton, CRow, CCol, CAlert
} from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

const ProductAdd = () => {
  const [form, setForm] = useState({
    name: '',
    description: '',
    fabric_type: '',
    category_id: '',
    gender: 'female',
    bodyType: 'Hourglass',
    productType: 'top',
    style: '["Casual"]', // as JSON string
    season_objectId: '[]', // as JSON string
    festival_objectId: '[]', // as JSON string
    care_instruction_objectId: '[]', // as JSON string
  })
  const [variant, setVariant] = useState({
    size: 'm',
    available_status: 'in_stock',
    ageGroup: '',
    skin_tone: '["Fair"]', // as JSON string
    under_tone: '["Cool"]', // as JSON string
    color: '',
    sku: '',
    stock_qty: '',
    barcode: '',
    price: '',
    discount_price: '',
    is_featured: false,
    is_new_arrival: false,
    is_best_seller: false,
    is_on_sale: false,
    is_on_trend: false,
    is_limited_edition: false,
    is_back_in_stock: false,
    is_pre_order: false,
    is_exclusive: false,
    is_eco_friendly: false,
    is_customizable: false,
    is_limited_time_offer: false,
    is_clearance: false,
    is_giftable: false,
    is_bundle: false,
    is_recommended: false,
    is_trending_near_you: false,
    is_celebrity_pick: false,
    is_festival_ready: false,
    isTryOn: false,
  })
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const navigate = useNavigate()

  const flags = {
    'is_featured': 'Featured',
    'is_new_arrival': 'New Arrival',
    'is_best_seller': 'Best Seller',
    'is_on_sale': 'On Sale',
    'is_on_trend': 'On Trend',
    'is_limited_edition': 'Limited Edition',
    'is_back_in_stock': 'Back in Stock',
    'is_pre_order': 'Pre Order',
    'is_exclusive': 'Exclusive',
    'is_eco_friendly': 'Eco Friendly',
    'is_customizable': 'Customizable',
    'is_limited_time_offer': 'Limited Time Offer',
    'is_clearance': 'Clearance',
    'is_giftable': 'Giftable',
    'is_bundle': 'Bundle',
    'is_recommended': 'Recommended',
    'is_trending_near_you': 'Trending Near You',
    'is_celebrity_pick': 'Celebrity Pick',
    'is_festival_ready': 'Festival Ready',
    'isTryOn': 'Try On'
  }

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value })
  }

  const handleVariantChange = (e) => {
    const { name, value, type, checked } = e.target
    setVariant({
      ...variant,
      [name]: type === 'checkbox' ? checked : value,
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    try {
      const formData = new FormData()
      Object.entries(form).forEach(([key, value]) => formData.append(key, value))
      // Variants as JSON string array
      formData.append('variants', JSON.stringify([{
        ...variant,
        skin_tone: JSON.parse(variant.skin_tone),
        under_tone: JSON.parse(variant.under_tone),
      }]))

      const res = await axios.post('http://localhost:3001/api/product/createProducts', formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })

      if (res.data.success) {
        setSuccess('Product added successfully!')
        setTimeout(() => navigate('/products'), 1000)
      } else {
        setError(res.data.message || 'Failed to add product')
      }
    } catch (err) {
      setError('Failed to add product')
    }
  }

  return (
    <CCard className="mb-4">
      <CCardHeader>
        <strong>Add Product</strong>
      </CCardHeader>
      <CCardBody>
        {error && <CAlert color="danger">{error}</CAlert>}
        {success && <CAlert color="success">{success}</CAlert>}
        <CForm onSubmit={handleSubmit}>
          <CRow>
            <CCol md={6}>
              <CFormInput label="Name" name="name" value={form.name} onChange={handleChange} required className="mb-3" />
              <CFormInput label="Description" name="description" value={form.description} onChange={handleChange} className="mb-3" />
              <CFormInput label="Fabric Type" name="fabric_type" value={form.fabric_type} onChange={handleChange} className="mb-3" />
              <CFormInput label="Category ID" name="category_id" value={form.category_id} onChange={handleChange} required className="mb-3" />
              <CFormInput label="Gender" name="gender" value={form.gender} onChange={handleChange} className="mb-3" />
              <CFormInput label="Body Type" name="bodyType" value={form.bodyType} onChange={handleChange} className="mb-3" />
              <CFormInput label="Product Type" name="productType" value={form.productType} onChange={handleChange} className="mb-3" />
              <CFormInput label="Style (JSON array)" name="style" value={form.style} onChange={handleChange} className="mb-3" />
              <CFormInput label="Season Object IDs (JSON array)" name="season_objectId" value={form.season_objectId} onChange={handleChange} className="mb-3" />
              <CFormInput label="Festival Object IDs (JSON array)" name="festival_objectId" value={form.festival_objectId} onChange={handleChange} className="mb-3" />
              <CFormInput label="Care Instruction Object IDs (JSON array)" name="care_instruction_objectId" value={form.care_instruction_objectId} onChange={handleChange} className="mb-3" />
            </CCol>
            <CCol md={6}>
              <h6>Variant</h6>
              <CFormInput label="Size" name="size" value={variant.size} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Available Status" name="available_status" value={variant.available_status} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Age Group" name="ageGroup" value={variant.ageGroup} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Skin Tone (JSON array)" name="skin_tone" value={variant.skin_tone} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Under Tone (JSON array)" name="under_tone" value={variant.under_tone} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Color" name="color" value={variant.color} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="SKU" name="sku" value={variant.sku} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Stock Qty" name="stock_qty" value={variant.stock_qty} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Barcode" name="barcode" value={variant.barcode} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Price" name="price" value={variant.price} onChange={handleVariantChange} className="mb-3" />
              <CFormInput label="Discount Price" name="discount_price" value={variant.discount_price} onChange={handleVariantChange} className="mb-3" />
              {/* Boolean flags */}
              {Object.entries(flags).map(([key, label]) => (
                <div key={key} className="form-check mb-1">
                  <input
                    className="form-check-input"
                    type="checkbox"
                    name={key}
                    checked={variant[key]}
                    onChange={handleVariantChange}
                    id={key}
                  />
                  <label className="form-check-label" htmlFor={key}>
                    {label}
                  </label>
                </div>
              ))}
            </CCol>
          </CRow>
          <CButton color="primary" type="submit" className="mt-3">Add Product</CButton>
        </CForm>
      </CCardBody>
    </CCard>
  )
}

export default ProductAdd