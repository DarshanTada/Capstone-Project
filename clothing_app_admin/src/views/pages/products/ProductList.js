import React, { useState } from 'react'
import {
  CCard, CCardBody, CCardHeader, CTable, CTableHead, CTableRow, CTableHeaderCell,
  CTableBody, CTableDataCell, CButton, CAvatar, CPagination, CPaginationItem, CFormInput
} from '@coreui/react'
import { useNavigate } from 'react-router-dom'
import tshirtImg from 'src/assets/images/products/T-Shirt.png'

const dummyProducts = [
  {
    id: 1,
    name: 'Classic T-Shirt',
    category: 'Tops',
    price: 19.99,
    stock: 120,
    images: [tshirtImg],
  },
  {
    id: 2,
    name: 'Denim Jeans',
    category: 'Bottoms',
    price: 39.99,
    stock: 80,
    image: 'https://via.placeholder.com/60x60?text=Jeans',
  },
  {
    id: 3,
    name: 'Summer Dress',
    category: 'Dresses',
    price: 29.99,
    stock: 50,
    image: 'https://via.placeholder.com/60x60?text=Dress',
  },
  {
    id: 4,
    name: 'Summer Dress',
    category: 'Dresses',
    price: 29.99,
    stock: 50,
    image: 'https://via.placeholder.com/60x60?text=Dress',
  },
  {
    id: 5,
    name: 'Summer Dress',
    category: 'Dresses',
    price: 29.99,
    stock: 50,
    image: 'https://via.placeholder.com/60x60?text=Dress',
  },
  // Add more products as needed
]

const ProductList = () => {
  const [products, setProducts] = useState(dummyProducts)
  const [search, setSearch] = useState('')
  const [productsPerPage, setProductsPerPage] = useState(5)
  const [currentPage, setCurrentPage] = useState(1)
  const navigate = useNavigate()

  // Filter products by search
  const filteredProducts = products.filter(
    (product) =>
      product.name.toLowerCase().includes(search.toLowerCase()) ||
      product.category.toLowerCase().includes(search.toLowerCase())
  )

  // Pagination logic
  const totalPages = Math.ceil(filteredProducts.length / productsPerPage)
  const paginatedProducts = filteredProducts.slice(
    (currentPage - 1) * productsPerPage,
    currentPage * productsPerPage
  )

  const handleDelete = (id) => {
    if (window.confirm('Are you sure you want to delete this product?')) {
      setProducts(products.filter((p) => p.id !== id))
    }
  }

  const handleSearchChange = (e) => {
    setSearch(e.target.value)
    setCurrentPage(1) // Reset to first page on search
  }

  const handlePageChange = (page) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page)
    }
  }

  const handleProductsPerPageChange = (e) => {
    setProductsPerPage(Number(e.target.value))
    setCurrentPage(1) // Reset to first page when changing page size
  }

  const pageOptions = [2, 3, 5, 10, 15, 20, 25, 50].filter(num => num < filteredProducts.length)
  if (filteredProducts.length > 0) pageOptions.push(filteredProducts.length)

  return (
    <CCard className="mb-4">
      <CCardHeader className="d-flex justify-content-between align-items-center">
        <strong>Product Listing</strong>
        <div>
          <label htmlFor="productsPerPage" className="me-2">Products per page:</label>
          <select
            id="productsPerPage"
            value={productsPerPage}
            onChange={handleProductsPerPageChange}
            className="form-select d-inline-block w-auto"
          >
            {pageOptions.map((num) => (
              <option key={num} value={num}>
                {num === filteredProducts.length ? 'All' : num}
              </option>
            ))}
          </select>
          <CButton color="primary" className="float-end ms-3" onClick={() => navigate('/products/add')}>
            Add Product
          </CButton>
        </div>
      </CCardHeader>
      <CCardBody>
        <div className="mb-3 d-flex justify-content-end">
          <CFormInput
            type="text"
            placeholder="Search by name or category"
            value={search}
            onChange={handleSearchChange}
            style={{ maxWidth: 300 }}
          />
        </div>
        <CTable align="middle" hover responsive>
          <CTableHead>
            <CTableRow>
              <CTableHeaderCell>Product ID</CTableHeaderCell>
              <CTableHeaderCell>Image</CTableHeaderCell>
              <CTableHeaderCell>Name</CTableHeaderCell>
              <CTableHeaderCell>Category</CTableHeaderCell>
              <CTableHeaderCell>Price</CTableHeaderCell>
              <CTableHeaderCell>Stock</CTableHeaderCell>
              <CTableHeaderCell>Actions</CTableHeaderCell>
            </CTableRow>
          </CTableHead>
          <CTableBody>
            {paginatedProducts.length === 0 ? (
              <CTableRow>
                <CTableDataCell colSpan={7} className="text-center">
                  No products found.
                </CTableDataCell>
              </CTableRow>
            ) : (
              paginatedProducts.map((product) => (
                <CTableRow key={product.id}>
                  <CTableDataCell>{product.id}</CTableDataCell>
                  <CTableDataCell>
                    <CAvatar
                      src={product.images ? product.images[0] : product.image}
                      size="md"
                    />
                  </CTableDataCell>
                  <CTableDataCell>{product.name}</CTableDataCell>
                  <CTableDataCell>{product.category}</CTableDataCell>
                  <CTableDataCell>${product.price.toFixed(2)}</CTableDataCell>
                  <CTableDataCell>{product.stock}</CTableDataCell>
                  <CTableDataCell>
                    <CButton
                      color="info"
                      size="sm"
                      className="me-2"
                      onClick={() => navigate(`/products/${product.id}`)}
                    >
                      View Product
                    </CButton>
                    <CButton color="danger" size="sm" onClick={() => handleDelete(product.id)}>
                      Delete
                    </CButton>
                  </CTableDataCell>
                </CTableRow>
              ))
            )}
          </CTableBody>
        </CTable>
        <CPagination className="justify-content-center my-3">
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
            disabled={currentPage === totalPages || totalPages === 0}
            onClick={() => handlePageChange(currentPage + 1)}
          >
            Next
          </CPaginationItem>
        </CPagination>
      </CCardBody>
    </CCard>
  )
}

export default ProductList