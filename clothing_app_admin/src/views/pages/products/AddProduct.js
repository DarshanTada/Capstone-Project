import React, { useState, useEffect } from 'react'

import {
  CCard, CCardBody, CCardHeader, CForm, CFormInput, CButton, CRow, CCol, CAlert, CFormSelect, CFormTextarea
} from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

const SIZE_OPTIONS = [
  { value: 'ex', label: 'Extra Small' },
  { value: 's', label: 'Small' },
  { value: 'm', label: 'Medium' },
  { value: 'l', label: 'Large' },
  { value: 'xl', label: 'Extra Large' },
]
const AVAILABILITY_OPTIONS = [
  { value: 'in_stock', label: 'In Stock' },
  { value: 'out_of_stock', label: 'Out of Stock' },
  { value: 'pre_order', label: 'Pre Order' },
]

const ProductAdd = () => {
  const [form, setForm] = useState({
    name: '',
    description: '',
    fabric_type: '',
    category_id: '',
    gender: '',
    bodyType: '',
    productType: '',
    style: '',
    season_objectId: '[]',
    festival_objectId: '[]',
    care_instruction_objectId: '[]',
  })
  const [variants, setVariants] = useState([])
  const [showVariantForm, setShowVariantForm] = useState(false)
  const [variant, setVariant] = useState({
    size: '',
    available_status: '',
    ageGroup: '',
    skin_tone: '',
    under_tone: '',
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
  const [variantImages, setVariantImages] = useState([]) // Array of File objects
  const [categories, setCategories] = useState([])
  const [subCategories, setSubCategories] = useState([])
  const [careInstructions, setCareInstructions] = useState([])
  const [seasons, setSeasons] = useState([])
  const [festivals, setFestivals] = useState([])
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [variantErrors, setVariantErrors] = useState({})
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

  // Fetch categories, seasons, and festivals on mount
  useEffect(() => {
    axios.get('http://localhost:3001/api/category/getCategory')
      .then(res => {
        if (res.data.success) {
          setCategories(res.data.data)
        }
      })
      .catch(() => setCategories([]))

    axios.get('http://localhost:3001/api/season/getSeasons')
      .then(res => {
        if (res.data.success) setSeasons(res.data.data)
      })
      .catch(() => setSeasons([]))

    axios.get('http://localhost:3001/api/festival/getFestivals')
      .then(res => {
        if (res.data.success) setFestivals(res.data.data)
      })
      .catch(() => setFestivals([]))
  }, [])

  // Fetch subcategories when category changes
  useEffect(() => {
    if (form.category_id) {
      axios.get(`http://localhost:3001/api/subcategory/bycategory/${form.category_id}`)
        .then(res => {
          if (res.data.success) {
            setSubCategories(res.data.data)
          } else {
            setSubCategories([])
          }
        })
        .catch(() => setSubCategories([]))
    } else {
      setSubCategories([])
    }
  }, [form.category_id])

  const handleChange = async (e) => {
    const { name, value } = e.target
    setForm((prev) => ({ ...prev, [name]: value }))
    if (name === 'fabric_type') {
      try {
        const res = await axios.post(
          'http://localhost:3001/api/careinstruction/get-care-instructions/by-fabric',
          { fabricType: value }
        )
        if (res.data.success && res.data.data && res.data.data.instructions) {
          setCareInstructions(res.data.data.instructions)
          setForm((prev) => ({
            ...prev,
            care_instruction_objectId: JSON.stringify(
              res.data.data.instructions.map((ci, idx) => ci._id || idx)
            ),
          }))
        } else {
          setCareInstructions([])
          setForm((prev) => ({ ...prev, care_instruction_objectId: '[]' }))
        }
      } catch {
        setCareInstructions([])
        setForm((prev) => ({ ...prev, care_instruction_objectId: '[]' }))
      }
    }
  }

  const handleVariantChange = (e) => {
    const { name, value, type, checked } = e.target
    setVariant({
      ...variant,
      [name]: type === 'checkbox' ? checked : value,
    })
    // Clear variant errors when user starts typing
    if (variantErrors[name]) {
      setVariantErrors(prev => ({ ...prev, [name]: '' }))
    }
  }

  // Validate variant before saving
  const validateVariant = () => {
    const errors = {}
    
    if (!variant.size.trim()) {
      errors.size = 'Size is required'
    }
    
    if (!variant.color.trim()) {
      errors.color = 'Color is required'
    }
    
    if (!variant.available_status) {
      errors.available_status = 'Availability status is required'
    }
    
    if (!variant.stock_qty || variant.stock_qty <= 0) {
      errors.stock_qty = 'Stock quantity is required and must be greater than 0'
    }
    
    if (!variant.price || variant.price <= 0) {
      errors.price = 'Price is required and must be greater than 0'
    }
    
    if (!variant.sku.trim()) {
      errors.sku = 'SKU is required'
    }
    
    if (variantImages.length === 0) {
      errors.images = 'At least one image is required for each variant'
    }
    
    // Check if SKU already exists in other variants
    const existingSKU = variants.find(v => v.sku === variant.sku)
    if (existingSKU) {
      errors.sku = 'SKU must be unique across all variants'
    }
    
    setVariantErrors(errors)
    return Object.keys(errors).length === 0
  }

  // Validate main form and variants before submission
  const validateFormAndVariants = () => {
    if (variants.length === 0) {
      setError('At least one variant must be added before creating the product')
      return false
    }
    
    // Check if all variants have required stock availability
    const variantsWithoutStock = variants.filter(v => !v.stock_qty || v.stock_qty <= 0)
    if (variantsWithoutStock.length > 0) {
      setError('All variants must have stock quantity greater than 0')
      return false
    }
    
    return true
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')

    // Validate form and variants
    if (!validateFormAndVariants()) {
      // Scroll to top to show error message
      window.scrollTo({ top: 0, behavior: 'smooth' })
      return
    }

    try {
      const formData = new FormData()
      
      // Append form data
      Object.entries(form).forEach(([key, value]) => formData.append(key, value))
      
      // Append variant images
      variants.forEach((variant, vIdx) => {
        if (variant.images && variant.images.length > 0) {
          variant.images.forEach((img, iIdx) => {
            formData.append(`variantImages_${vIdx}_${iIdx}`, img.file)
          })
        }
      })
      
      // Append variants data (without image files)
      formData.append('variants', JSON.stringify(
        variants.map(v => ({
          ...v,
          skin_tone: JSON.parse(v.skin_tone || '[]'),
          under_tone: JSON.parse(v.under_tone || '[]'),
          stock_qty: parseInt(v.stock_qty),
          price: parseFloat(v.price),
          discount_price: v.discount_price ? parseFloat(v.discount_price) : null,
          images: undefined // Don't send File objects in JSON
        }))
      ))

      console.log('Submitting product with variants:', variants.length)

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
      console.error('Error creating product:', err)
      setError(err.response?.data?.message || 'Failed to add product')
    }
  }

  const GENDER = [
    { value: 'male', label: 'Male' },
    { value: 'female', label: 'Female' },
    { value: 'other', label: 'Other' },
  ]

  const BODYTYPE_FEMALE = [
    { value: 'Hourglass', label: 'Hourglass' },
    { value: 'Triangle', label: 'Triangle' },
    { value: 'Round', label: 'Round' },
    { value: 'Straight', label: 'Straight' },
    { value: 'Inverted Triangle', label: 'Inverted Triangle' },
  ]

  const BODYTYPE_MALE = [
    { value: 'Ectomorph', label: 'Ectomorph' },
    { value: 'Mesomorph', label: 'Mesomorph' },
    { value: 'Endomorph', label: 'Endomorph' },
  ]

  const BODYTYPE_OTHER = [
    { value: 'Hourglass', label: 'Hourglass' },
    { value: 'Triangle', label: 'Triangle' },
    { value: 'Round', label: 'Round' },
    { value: 'Straight', label: 'Straight' },
    { value: 'Inverted Triangle', label: 'Inverted Triangle' },
    { value: 'Ectomorph', label: 'Ectomorph' },
    { value: 'Mesomorph', label: 'Mesomorph' },
    { value: 'Endomorph', label: 'Endomorph' },
  ]

  const PRODUCTTYPE = [
    { value: 'top', label: 'Top' },
    { value: 'bottom', label: 'Bottom' },
  ]

  const getBodyTypeOptions = () => {
    if (form.gender === 'female') return BODYTYPE_FEMALE
    if (form.gender === 'male') return BODYTYPE_MALE
    if (form.gender === 'other') return BODYTYPE_OTHER
    return []
  }

  const handleImageChange = (e) => {
    const files = Array.from(e.target.files)
    const imageList = files.map((file, i) => ({
      file,
      is_primary: i === 0,
      sort_order: i,
    }))
    setVariantImages(imageList)
    // Clear image error when user selects images
    if (variantErrors.images) {
      setVariantErrors(prev => ({ ...prev, images: '' }))
    }
  }

  const saveVariant = () => {
    if (!validateVariant()) {
      return
    }

    // Ensure numeric values are properly converted
    const processedVariant = {
      ...variant,
      stock_qty: parseInt(variant.stock_qty),
      price: parseFloat(variant.price),
      discount_price: variant.discount_price ? parseFloat(variant.discount_price) : null,
      images: variantImages
    }

    setVariants([...variants, processedVariant])
    
    // Reset variant form
    setVariant({
      size: '',
      available_status: '',
      ageGroup: '',
      skin_tone: '',
      under_tone: '',
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
    setVariantImages([])
    setVariantErrors({})
    setShowVariantForm(false)
    setSuccess('Variant added successfully!')
    
    // Clear success message after 3 seconds
    setTimeout(() => setSuccess(''), 3000)
  }

  const removeVariant = (index) => {
    const updatedVariants = variants.filter((_, i) => i !== index)
    setVariants(updatedVariants)
  }

  const editVariant = (index) => {
    const variantToEdit = variants[index]
    setVariant(variantToEdit)
    setVariantImages(variantToEdit.images || [])
    setShowVariantForm(true)
    removeVariant(index)
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
              <CFormTextarea
                label="Description"
                name="description"
                value={form.description}
                onChange={handleChange}
                required
                rows={form.description.length > 80 ? 6 : 3}
                className="mb-3"
              />
              <CFormSelect
                label="Fabric Type"
                name="fabric_type"
                value={form.fabric_type}
                onChange={handleChange}
                required
                className="mb-3"
              >
                <option value="">Select Fabric Type</option>
                <option value="Cotton">Cotton</option>
                <option value="Khadi">Khadi</option>
                <option value="Linen">Linen</option>
              </CFormSelect>
              <CFormTextarea
                label="Care Instructions"
                value={careInstructions.map(ci => ci.instruction).join('\n')}
                disabled
                rows={careInstructions.length > 2 ? careInstructions.length : 2}
                className="mb-3"
              />
              <CFormSelect
                label="Category"
                name="category_id"
                value={form.category_id}
                onChange={handleChange}
                required
                className="mb-3"
              >
                <option value="">Select Category</option>
                {categories.map(cat => (
                  <option key={cat._id} value={cat._id}>{cat.name}</option>
                ))}
              </CFormSelect>
              <CFormTextarea
                label="Subcategories"
                value={subCategories.map(sub => sub.name).join('\n')}
                disabled
                rows={subCategories.length > 2 ? subCategories.length : 2}
                className="mb-3"
              />
              <div className="mb-3">
                <label className="form-label d-block">Gender</label>
                {GENDER.map(opt => (
                  <div className="form-check form-check-inline" key={opt.value}>
                    <input
                      className="form-check-input"
                      type="radio"
                      name="gender"
                      id={`gender-${opt.value}`}
                      value={opt.value}
                      checked={form.gender === opt.value}
                      onChange={handleChange}
                      required
                    />
                    <label className="form-check-label" htmlFor={`gender-${opt.value}`}>{opt.label}</label>
                  </div>
                ))}
              </div>
              <CFormSelect
                label="Body Type"
                name="bodyType"
                value={form.bodyType}
                onChange={handleChange}
                required
                className="mb-3"
              >
                <option value="">Select Body Type</option>
                {getBodyTypeOptions().map(opt => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </CFormSelect>
              <CFormSelect
                label="Product Type"
                name="productType"
                value={form.productType}
                onChange={handleChange}
                required
                className="mb-3"
              >
                <option value="">Select Product Type</option>
                {PRODUCTTYPE.map(opt => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </CFormSelect>
              <CFormSelect
                label="Style"
                name="style"
                value={form.style}
                onChange={handleChange}
                required
                className="mb-3"
              >
                <option value="">Select Style</option>
                <option value="Casual">Casual</option>
                <option value="Formal">Formal</option>
                <option value="Ethnic">Ethnic</option>
              </CFormSelect>
              <CFormSelect
                label="Season"
                name="season_objectId"
                value={form.season_objectId}
                onChange={handleChange}
                className="mb-3"
              >
                <option value="">Select Season</option>
                {seasons.map(season => (
                  <option key={season._id} value={season._id}>{season.season_name}</option>
                ))}
              </CFormSelect>
              <CFormSelect
                label="Festival"
                name="festival_objectId"
                value={form.festival_objectId}
                onChange={handleChange}
                className="mb-3"
              >
                <option value="">Select Festival</option>
                {festivals.map(festival => (
                  <option key={festival._id} value={festival._id}>{festival.festival_name}</option>
                ))}
              </CFormSelect>
            </CCol>
          </CRow>
          
          {/* Submit Button moved inside form but at the bottom */}
          <div className="mt-4 pt-3 border-top">
            <CButton 
              color="primary" 
              type="submit" 
              size="lg"
              disabled={variants.length === 0}
            >
              Create Product
            </CButton>
            {variants.length === 0 && (
              <div className="text-muted small mt-2">
                Add at least one variant to create the product
              </div>
            )}
          </div>
        </CForm>

        {/* Variants Section */}
        <div className="mt-4">
          <div className="d-flex justify-content-between align-items-center mb-3">
            <h5>Product Variants {variants.length === 0 && <span className="text-danger">*</span>}</h5>
            <CButton
              color="primary"
              onClick={() => setShowVariantForm(true)}
              disabled={showVariantForm}
            >
              Add Variant
            </CButton>
          </div>

          {variants.length === 0 && (
            <CAlert color="warning">
              <strong>Notice:</strong> At least one variant must be added before the product can be created.
            </CAlert>
          )}

          {/* Variant Form */}
          {showVariantForm && (
            <div className="mb-4 border p-3 rounded">
              <h6>Add New Variant</h6>
              
              <CRow>
                <CCol md={6}>
                  <CFormSelect
                    label="Size *"
                    name="size"
                    className="mb-2"
                    value={variant.size}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.size}
                  >
                    <option value="">Select Size</option>
                    {SIZE_OPTIONS.map((opt) => (
                      <option key={opt.value} value={opt.value}>
                        {opt.label}
                      </option>
                    ))}
                  </CFormSelect>
                  {variantErrors.size && <div className="text-danger small mb-2">{variantErrors.size}</div>}

                  <CFormInput
                    label="Color *"
                    name="color"
                    className="mb-2"
                    value={variant.color}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.color}
                  />
                  {variantErrors.color && <div className="text-danger small mb-2">{variantErrors.color}</div>}

                  <CFormSelect
                    label="Available Status *"
                    name="available_status"
                    className="mb-2"
                    value={variant.available_status}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.available_status}
                  >
                    <option value="">Select Availability</option>
                    {AVAILABILITY_OPTIONS.map((opt) => (
                      <option key={opt.value} value={opt.value}>
                        {opt.label}
                      </option>
                    ))}
                  </CFormSelect>
                  {variantErrors.available_status && <div className="text-danger small mb-2">{variantErrors.available_status}</div>}
                </CCol>
                <CCol md={6}>
                  <CFormInput
                    label="SKU *"
                    name="sku"
                    className="mb-2"
                    value={variant.sku}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.sku}
                  />
                  {variantErrors.sku && <div className="text-danger small mb-2">{variantErrors.sku}</div>}

                  <CFormInput
                    label="Stock Quantity *"
                    name="stock_qty"
                    type="number"
                    min="1"
                    className="mb-2"
                    value={variant.stock_qty}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.stock_qty}
                  />
                  {variantErrors.stock_qty && <div className="text-danger small mb-2">{variantErrors.stock_qty}</div>}

                  <CFormInput
                    label="Price *"
                    name="price"
                    type="number"
                    step="0.01"
                    min="0.01"
                    className="mb-2"
                    value={variant.price}
                    onChange={handleVariantChange}
                    invalid={!!variantErrors.price}
                  />
                  {variantErrors.price && <div className="text-danger small mb-2">{variantErrors.price}</div>}

                  <CFormInput
                    label="Discount Price"
                    name="discount_price"
                    type="number"
                    step="0.01"
                    min="0"
                    className="mb-2"
                    value={variant.discount_price}
                    onChange={handleVariantChange}
                  />

                  <CFormInput
                    label="Barcode"
                    name="barcode"
                    className="mb-2"
                    value={variant.barcode}
                    onChange={handleVariantChange}
                  />
                </CCol>
              </CRow>

              <CFormInput
                type="file"
                label="Upload Variant Images *"
                multiple
                accept=".png,.jpg,.jpeg"
                className="mb-3"
                onChange={handleImageChange}
                invalid={!!variantErrors.images}
              />
              {variantErrors.images && <div className="text-danger small mb-2">{variantErrors.images}</div>}

              {/* Image Management */}
              {variantImages.map((img, idx) => (
                <div key={idx} className="mb-3 p-2 border rounded">
                  <div className="d-flex justify-content-between align-items-center mb-2">
                    <strong>Image {idx + 1}: {img.file.name}</strong>
                    <CButton 
                      size="sm" 
                      color="danger" 
                      variant="outline"
                      onClick={() => {
                        const updated = variantImages.filter((_, i) => i !== idx)
                        setVariantImages(updated)
                      }}
                    >
                      Remove
                    </CButton>
                  </div>
                  <CRow>
                    <CCol md={6}>
                      <CFormInput
                        type="number"
                        label="Sort Order"
                        value={img.sort_order}
                        onChange={(e) => {
                          const updated = [...variantImages]
                          updated[idx].sort_order = parseInt(e.target.value, 10)
                          setVariantImages(updated)
                        }}
                      />
                    </CCol>
                    <CCol md={6}>
                      <div className="form-check mt-4">
                        <input
                          type="radio"
                          name="primaryImage"
                          checked={img.is_primary}
                          onChange={() => {
                            const updated = variantImages.map((vimg, vidx) => ({
                              ...vimg,
                              is_primary: vidx === idx,
                            }))
                            setVariantImages(updated)
                          }}
                          className="form-check-input"
                        />
                        <label className="form-check-label">Set as Primary Image</label>
                      </div>
                    </CCol>
                  </CRow>
                </div>
              ))}

              {/* Feature Flags */}
              <div className="mb-3">
                <h6>Product Features</h6>
                <CRow>
                  {Object.entries(flags).map(([key, label], index) => (
                    <CCol md={4} key={key}>
                      <div className="form-check mb-2">
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
                    </CCol>
                  ))}
                </CRow>
              </div>

              <div className="d-flex gap-2">
                <CButton color="success" onClick={saveVariant}>
                  Save Variant
                </CButton>
                <CButton 
                  color="secondary" 
                  onClick={() => {
                    setShowVariantForm(false)
                    setVariant({
                      size: '',
                      available_status: '',
                      ageGroup: '',
                      skin_tone: '',
                      under_tone: '',
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
                    setVariantImages([])
                    setVariantErrors({})
                  }}
                >
                  Cancel
                </CButton>
              </div>
            </div>
          )}

          {/* Display Added Variants */}
          {variants.length > 0 && (
            <div className="mt-3">
              <h6>Added Variants ({variants.length})</h6>
              <div className="table-responsive">
                <table className="table table-bordered">
                  <thead>
                    <tr>
                      <th>Size</th>
                      <th>Color</th>
                      <th>SKU</th>
                      <th>Stock</th>
                      <th>Price</th>
                      <th>Status</th>
                      <th>Images</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {variants.map((v, i) => (
                      <tr key={i}>
                        <td>{v.size}</td>
                        <td>{v.color}</td>
                        <td>{v.sku}</td>
                        <td>{v.stock_qty}</td>
                        <td>${v.price}</td>
                        <td>
                          <span className={`badge ${
                            v.available_status === 'in_stock' ? 'bg-success' : 
                            v.available_status === 'out_of_stock' ? 'bg-danger' : 'bg-warning'
                          }`}>
                            {AVAILABILITY_OPTIONS.find(opt => opt.value === v.available_status)?.label || v.available_status}
                          </span>
                        </td>
                        <td>{v.images?.length || 0} images</td>
                        <td>
                          <div className="d-flex gap-1">
                            <CButton 
                              size="sm" 
                              color="info" 
                              variant="outline"
                              onClick={() => editVariant(i)}
                              disabled={showVariantForm}
                            >
                              Edit
                            </CButton>
                            <CButton 
                              size="sm" 
                              color="danger" 
                              variant="outline"
                              onClick={() => removeVariant(i)}
                            >
                              Remove
                            </CButton>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>

        {/* Submit Button */}
        <div className="mt-4 pt-3 border-top d-none">
          <CButton 
            color="primary" 
            type="submit" 
            size="lg"
            disabled={variants.length === 0}
            onClick={handleSubmit}
          >
            Create Product
          </CButton>
          {variants.length === 0 && (
            <div className="text-muted small mt-2">
              Add at least one variant to create the product
            </div>
          )}
        </div>
      </CCardBody>
    </CCard>
  )
}

export default ProductAdd