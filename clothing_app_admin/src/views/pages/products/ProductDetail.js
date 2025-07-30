import React, { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import {
  CCard, CCardBody, CCardHeader, CButton, CForm, CFormInput, CFormLabel,
  CRow, CCol, CFormTextarea, CFormSelect, CAlert
} from '@coreui/react'
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

const ProductDetail = () => {
  // Handler for updating a single variant (for demo, just shows a success message)
  const handleUpdateVariant = (idx) => {
    setSuccess(`Variant ${idx + 1} updated! (This is a placeholder, implement backend call as needed)`);
    setTimeout(() => setSuccess(''), 2000);
  }
  const { id } = useParams()
  const navigate = useNavigate()
  const [form, setForm] = useState(null)
  const [variants, setVariants] = useState([])
  const [images, setImages] = useState([])
  const [categories, setCategories] = useState([])
  const [seasons, setSeasons] = useState([])
  const [festivals, setFestivals] = useState([])
  const [careInstructions, setCareInstructions] = useState([])
  const [subCategories, setSubCategories] = useState([])
  const [isEditing, setIsEditing] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [showAddVariantForm, setShowAddVariantForm] = useState(false)

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        const res = await axios.get(`http://localhost:3001/api/product/getProductDetail/${id}`)
        if (res.data.success && res.data.data && res.data.data.productDetail) {
          const product = res.data.data.productDetail
          setForm({
            ...product,
            subcategory_id: product.subcategory_id?._id || product.subcategory_id || '',
            style: Array.isArray(product.style) ? product.style.join(', ') : product.style || '',
            season_objectId: product.season_objectId || [],
            festival_objectId: product.festival_objectId || [],
            care_instruction_objectId: product.care_instruction_objectId || [],
          })
          setVariants(product.variants || [])
          setImages(product.images || [])
          setError('')
        } else {
          setForm(null)
          setError('Product not found')
        }
      } catch (err) {
        setForm(null)
        setError('Failed to fetch product')
      }
    }
    fetchProduct()
  }, [id])

  useEffect(() => {
    axios.get('http://localhost:3001/api/category/getCategory')
      .then(res => setCategories(res.data.data || []))
      .catch(() => setCategories([]))
    axios.get('http://localhost:3001/api/season/getSeasons')
      .then(res => setSeasons(res.data.data || []))
      .catch(() => setSeasons([]))
    axios.get('http://localhost:3001/api/festival/getFestivals')
      .then(res => setFestivals(res.data.data || []))
      .catch(() => setFestivals([]))
  }, [])

  useEffect(() => {
    if (form?.category_id?._id || form?.category_id) {
      axios.get(`http://localhost:3001/api/subcategory/getByCategory/${form.category_id?._id || form.category_id}`)
        .then(res => setSubCategories(res.data.data || []))
        .catch(() => setSubCategories([]))
    }
  }, [form?.category_id])

  useEffect(() => {
    if (form && form.fabric_type) {
      axios.post('http://localhost:3001/api/careinstruction/get-care-instructions/by-fabric', { fabricType: form.fabric_type })
        .then(res => {
          // The backend returns { success, data: { fabricType, instructions: [...] } }
          setCareInstructions(res.data.data?.instructions || [])
        })
        .catch(() => setCareInstructions([]))
    } else {
      setCareInstructions([])
    }
  }, [form?.fabric_type])

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target
    setForm((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }))
  }

  const handleVariantChange = (idx, e) => {
    const { name, value, type, checked } = e.target
    setVariants((prev) =>
      prev.map((v, i) =>
        i === idx ? { ...v, [name]: type === 'checkbox' ? checked : value } : v
      )
    )
  }

  const handleSave = async (e) => {
    e.preventDefault()
    setError('')
    setSuccess('')
    try {
      const payload = {
        productId: form._id,
        name: form.name,
        description: form.description,
        fabric_type: form.fabric_type,
        category_id: form.category_id?._id || form.category_id,
        subcategory_id: form.subcategory_id?._id || form.subcategory_id || '',
        gender: form.gender,
        bodyType: form.bodyType,
        productType: form.productType,
        style: form.style.split(',').map(s => s.trim()),
        season_objectId: Array.isArray(form.season_objectId)
          ? form.season_objectId.map(obj => obj._id || obj)
          : form.season_objectId ? [form.season_objectId._id || form.season_objectId] : [],
        festival_objectId: Array.isArray(form.festival_objectId)
          ? form.festival_objectId.map(obj => obj._id || obj)
          : form.festival_objectId ? [form.festival_objectId._id || form.festival_objectId] : [],
        care_instruction_objectId: Array.isArray(form.care_instruction_objectId)
          ? form.care_instruction_objectId.map(obj => obj._id || obj)
          : form.care_instruction_objectId ? [form.care_instruction_objectId._id || form.care_instruction_objectId] : [],
        variants: variants.map(v => ({
          ...v,
          stock_qty: parseInt(v.stock_qty),
          price: parseFloat(v.price),
          discount_price: v.discount_price ? parseFloat(v.discount_price) : null,
        })),
      }
      await axios.put(`http://localhost:3001/api/product/updateProduct/${form._id}`, payload)
      setSuccess('Product updated successfully!')
      setIsEditing(false)
    } catch (err) {
      setError('Failed to update product')
    }
  }


  if (error) return <div className="d-flex justify-content-center align-items-center" style={{ minHeight: 200 }}><CAlert color="danger">{error}</CAlert></div>;
  if (!form) return <div className="d-flex justify-content-center align-items-center" style={{ minHeight: 200 }}><span className="spinner-border text-primary" role="status" aria-hidden="true"></span><span className="ms-2">Loading product details...</span></div>;

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
              <CButton
                color="primary"
                className="float-end"
                onClick={() => {
                  // Always pass objects/arrays, never just IDs
                  const categoryObj = categories.find(cat => cat._id === (form.category_id?._id || form.category_id)) || {};
                  const subcategoryObj = (Array.isArray(subCategories) && subCategories.length > 0
                    ? subCategories.find(sub => sub._id === (form.subcategory_id?._id || form.subcategory_id))
                    : {});
                  const careInstructionsArr = Array.isArray(careInstructions) ? careInstructions : [];
                  const variantsArr = Array.isArray(variants) ? variants : [];
                  navigate('/products/add', {
                    state: {
                      product: form,
                      category: categoryObj,
                      subcategory: subcategoryObj,
                      careInstructions: careInstructionsArr,
                      variants: variantsArr,
                    }
                  });
                }}
              >
                Edit
              </CButton>
            )}
          </CCardHeader>
          <CCardBody>
            {error && <CAlert color="danger">{error}</CAlert>}
            {success && <CAlert color="success">{success}</CAlert>}

            {/* Display all product images */}
            {images.length > 0 && (
              <>
                <h5 className="mb-3">All Product Images</h5>
                <div className="d-flex flex-wrap gap-3 mb-4 justify-content-center">
                  {images.map((img, idx) => (
                    <img
                      key={idx}
                      src={`data:${img.image.contentType};base64,${img.image.base64}`}
                      alt={`Product Image ${idx + 1}`}
                      style={{
                        width: 80,
                        height: 80,
                        objectFit: 'cover',
                        borderRadius: 8,
                        border: '1px solid #ccc',
                      }}
                    />
                  ))}
                </div>
              </>
            )}

            <CForm onSubmit={handleSave}>
              <CRow className="g-3">
                <CCol md={6}>
                  <CFormLabel>Name</CFormLabel>
                  <CFormInput name="name" value={form.name} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Description</CFormLabel>
                  <CFormTextarea name="description" value={form.description} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Fabric Type</CFormLabel>
                  <CFormSelect name="fabric_type" value={form.fabric_type} onChange={handleChange} disabled={!isEditing}>
                    <option value="">Select Fabric Type</option>
                    <option value="Cotton">Cotton</option>
                    <option value="Khadi">Khadi</option>
                    <option value="Linen">Linen</option>
                  </CFormSelect>
                  <CFormLabel className="mt-2">Category</CFormLabel>
                  <CFormSelect name="category_id" value={form.category_id?._id || form.category_id} onChange={handleChange} disabled={!isEditing}>
                    <option value="">Select Category</option>
                    {categories.map(cat => (
                      <option key={cat._id} value={cat._id}>{cat.name}</option>
                    ))}
                  </CFormSelect>
                  <CFormLabel className="mt-2">Subcategory</CFormLabel>
                  {isEditing ? (
                    <CFormSelect
                      name="subcategory_id"
                      value={form.subcategory_id?._id || form.subcategory_id || ''}
                      onChange={handleChange}
                      disabled={!isEditing}
                    >
                      <option value="">Select Subcategory</option>
                      {subCategories.map(sub => (
                        <option key={sub._id} value={sub._id}>{sub.name}</option>
                      ))}
                    </CFormSelect>
                  ) : (
                    <CFormInput
                      value={
                        form.subcategory_id && typeof form.subcategory_id === 'object'
                          ? form.subcategory_id.name
                          : (
                            subCategories.find(sub => sub._id === form.subcategory_id)?.name || ''
                          )
                      }
                      disabled
                    />
                  )}
                  <CFormLabel className="mt-2">Gender</CFormLabel>
                  <CFormSelect name="gender" value={form.gender} onChange={handleChange} disabled={!isEditing}>
                    <option value="">Select Gender</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                    <option value="other">Other</option>
                  </CFormSelect>
                  <CFormLabel className="mt-2">Body Type</CFormLabel>
                  <CFormInput name="bodyType" value={form.bodyType} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Product Type</CFormLabel>
                  <CFormSelect name="productType" value={form.productType} onChange={handleChange} disabled={!isEditing}>
                    <option value="">Select Product Type</option>
                    <option value="top">Top</option>
                    <option value="bottom">Bottom</option>
                  </CFormSelect>
                  <CFormLabel className="mt-2">Style</CFormLabel>
                  <CFormInput name="style" value={form.style} onChange={handleChange} disabled={!isEditing} />
                  <CFormLabel className="mt-2">Season</CFormLabel>
                  <CFormSelect
                    name="season_objectId"
                    value={Array.isArray(form.season_objectId) && form.season_objectId.length > 0
                      ? (form.season_objectId[0]._id || form.season_objectId[0])
                      : ''}
                    onChange={handleChange}
                    disabled={!isEditing}
                  >
                    <option value="">Select Season</option>
                    {seasons.map(season => (
                      <option key={season._id} value={season._id}>{season.season_name}</option>
                    ))}
                  </CFormSelect>
                  <CFormLabel className="mt-2">Festival</CFormLabel>
                  <CFormSelect
                    name="festival_objectId"
                    value={Array.isArray(form.festival_objectId) && form.festival_objectId.length > 0
                      ? (form.festival_objectId[0]._id || form.festival_objectId[0])
                      : ''}
                    onChange={handleChange}
                    disabled={!isEditing}
                  >
                    <option value="">Select Festival</option>
                    {festivals.map(festival => (
                      <option key={festival._id} value={festival._id}>{festival.festival_name}</option>
                    ))}
                  </CFormSelect>
                  <CFormLabel className="mt-2">Care Instructions</CFormLabel>
                  <CFormTextarea value={careInstructions.map(ci => ci.instruction).join('\n')} disabled rows={careInstructions.length > 2 ? careInstructions.length : 2} />
                </CCol>
              </CRow>
              <hr />
              <h5>Variants</h5>
              {variants.map((variant, idx) => (
                <div key={variant._id || idx} className="mb-4 border p-3 rounded">
                  <CRow>
                    <CCol md={4}>
                      <CFormLabel>Size</CFormLabel>
                      <CFormSelect
                        name="size"
                        value={variant.size}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      >
                        <option value="">Select Size</option>
                        {SIZE_OPTIONS.map(opt => (
                          <option key={opt.value} value={opt.value}>{opt.label}</option>
                        ))}
                      </CFormSelect>
                    </CCol>
                    <CCol md={4}>
                      <CFormLabel>Color</CFormLabel>
                      <CFormInput
                        name="color"
                        value={variant.color}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                    <CCol md={4}>
                      <CFormLabel>Available Status</CFormLabel>
                      <CFormSelect
                        name="available_status"
                        value={variant.available_status}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      >
                        <option value="">Select Availability</option>
                        {AVAILABILITY_OPTIONS.map(opt => (
                          <option key={opt.value} value={opt.value}>{opt.label}</option>
                        ))}
                      </CFormSelect>
                    </CCol>
                  </CRow>
                  <CRow className="mt-2">
                    <CCol md={4}>
                      <CFormLabel>Avatar URL</CFormLabel>
                      <CFormInput
                        name="avatarUrl"
                        value={variant.avatarUrl || ''}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                      {variant.avatarUrl && (
                        <img src={variant.avatarUrl} alt="Avatar" style={{ width: 60, height: 60, objectFit: 'cover', borderRadius: 6, marginTop: 8 }} />
                      )}
                    </CCol>
                  </CRow>
                  <CRow className="mt-2">
                    <CCol md={4}>
                      <CFormLabel>SKU</CFormLabel>
                      <CFormInput
                        name="sku"
                        value={variant.sku}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                    <CCol md={4}>
                      <CFormLabel>Stock Quantity</CFormLabel>
                      <CFormInput
                        name="stock_qty"
                        type="number"
                        value={variant.stock_qty}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                    <CCol md={4}>
                      <CFormLabel>Price</CFormLabel>
                      <CFormInput
                        name="price"
                        type="number"
                        value={variant.price}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                  </CRow>
                  <CRow className="mt-2">
                    <CCol md={4}>
                      <CFormLabel>Discount Price</CFormLabel>
                      <CFormInput
                        name="discount_price"
                        type="number"
                        value={variant.discount_price}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                    <CCol md={4}>
                      <CFormLabel>Barcode</CFormLabel>
                      <CFormInput
                        name="barcode"
                        value={variant.barcode}
                        onChange={e => handleVariantChange(idx, e)}
                        disabled={!isEditing}
                      />
                    </CCol>
                    <CCol md={4} className="d-flex align-items-end">
                      {isEditing && (
                        <CButton color="info" size="sm" onClick={() => handleUpdateVariant(idx)}>
                          Update Variant
                        </CButton>
                      )}
                    </CCol>
                  </CRow>
                  <CRow className="mt-2">
                    <CCol md={12}>
                      {/* <CFormLabel>Images</CFormLabel>
                      <div className="d-flex flex-wrap gap-2">
                        {images
                          .filter(img => img.productVariantObjectId === variant._id)
                          .map((img, i) => (
                            <img
                              key={i}
                              src={`data:${img.image.contentType};base64,${img.image.base64}`}
                              alt={`Variant ${idx + 1} Image ${i + 1}`}
                              style={{ width: 60, height: 60, objectFit: 'cover', borderRadius: 6 }}
                            />
                          ))}
                      </div> */}
                      {isEditing && (
                        <CFormInput
                          type="file"
                          multiple
                          accept=".png,.jpg,.jpeg,.webp"
                          className="mt-2"
                          onChange={e => handleVariantImageUpload(idx, e)}
                        />
                      )}
                    </CCol>
                  </CRow>
                </div>
              ))}
              {isEditing && (
                <CButton
                  color="success"
                  className="mb-3"
                  onClick={() => setShowAddVariantForm(true)}
                >
                  Add New Variant
                </CButton>
              )}
              {isEditing && (
                <CRow>
                  <CCol className="d-flex justify-content-center">
                    <CButton className="my-3" color="primary" type="submit">
                      Update Product
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
