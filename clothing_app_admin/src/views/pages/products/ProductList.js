import React, { useState, useEffect } from 'react';
import {
  CCard, CCardBody, CCardHeader, CTable, CTableHead, CTableRow, CTableHeaderCell,
  CTableBody, CTableDataCell, CButton, CPagination, CPaginationItem, CFormInput
} from '@coreui/react';
import { useNavigate, useLocation } from 'react-router-dom';
import { ROLE, hasPermission } from 'src/roles/permissions';
import axios from 'axios';

const ProductList = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState('');
  const [productsPerPage, setProductsPerPage] = useState(5);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [categories, setCategories] = useState([]);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    fetchProducts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [currentPage, productsPerPage, location.pathname]);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchProducts = async () => {
    setLoading(true);
    try {
      const res = await axios.get('http://localhost:3001/api/product/getProduct', {
        params: {
          page: currentPage,
          limit: productsPerPage,
        }
      });
      if (res.data.success) {
        setProducts(res.data.data);
        setTotalPages(res.data.pagination.totalPages);
      }
    } catch (err) {
      console.error('Failed to fetch products:', err);
    }
    setLoading(false);
  };

  const fetchCategories = async () => {
    try {
      const res = await axios.get('http://localhost:3001/api/category/getCategory');
      if (res.data.success) {
        setCategories(res.data.data);
      }
    } catch (err) {
      console.error('Failed to fetch categories:', err);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this product?')) {
      try {
        await axios.delete(`http://localhost:3001/api/product/deleteProduct/${id}`);
        setProducts(products.filter((p) => p._id !== id));
      } catch (err) {
        alert('Failed to delete product.');
      }
    }
  };

  const handleSearchChange = (e) => {
    setSearch(e.target.value);
    setCurrentPage(1);
  };

  const handlePageChange = (page) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page);
    }
  };

  const handleProductsPerPageChange = async (e) => {
    const value = Number(e.target.value);
    // If 'All' is selected, fetch total count and set as limit
    if (value === products.length) {
      try {
        const res = await axios.get('http://localhost:3001/api/product/getProduct', { params: { page: 1, limit: 1 } });
        if (res.data && res.data.pagination && res.data.pagination.total) {
          setProductsPerPage(res.data.pagination.total);
        } else {
          setProductsPerPage(10000); // fallback
        }
      } catch {
        setProductsPerPage(10000);
      }
    } else {
      setProductsPerPage(value);
    }
    setCurrentPage(1);
  };

  const pageOptions = [2, 3, 5, 10, 15, 20, 25, 50].filter(num => num < products.length);
  if (products.length > 0) pageOptions.push(products.length);

  // Filter products by search (client-side search on current page only)
  const filteredProducts = products.filter(
    (product) =>
      product.name.toLowerCase().includes(search.toLowerCase()) ||
      (product.category_id && product.category_id.name && product.category_id.name.toLowerCase().includes(search.toLowerCase()))
  );

  // Use backend pagination: products is already paginated
  const paginatedProducts = filteredProducts;
  const totalFilteredPages = totalPages;

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
                {num === products.length ? 'All' : num}
              </option>
            ))}
          </select>
          {/* Refresh button removed: now auto-refreshes on navigation */}
          {(hasPermission('admin', 'manage_products') || hasPermission('super_admin', 'manage_products') || hasPermission('product_manager', 'manage_products')) && (
            <CButton color="primary" className="float-end ms-3" onClick={() => navigate('/products/add')}>
              Add Product
            </CButton>
          )}
        </div>
      </CCardHeader>
      <CCardBody>
        {loading ? (
          <div className="d-flex justify-content-center align-items-center" style={{ minHeight: 200 }}>
            <span className="spinner-border text-primary" role="status" aria-hidden="true"></span>
            <span className="ms-2">Loading products...</span>
          </div>
        ) : (
          <>
            <div className="mb-3 d-flex justify-content-end align-items-center">
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
                  <CTableHeaderCell>Name</CTableHeaderCell>
                  <CTableHeaderCell>Category</CTableHeaderCell>
                  <CTableHeaderCell>Image</CTableHeaderCell>
                  <CTableHeaderCell>Price</CTableHeaderCell>
                  <CTableHeaderCell>Stock</CTableHeaderCell>
                  {(hasPermission('admin', 'manage_products') || hasPermission('super_admin', 'manage_products') || hasPermission('product_manager', 'manage_products')) && <CTableHeaderCell>Actions</CTableHeaderCell>}
                </CTableRow>
              </CTableHead>
              <CTableBody>
                {paginatedProducts.length === 0 ? (
                  <CTableRow>
                    <CTableDataCell colSpan={hasPermission(ROLE.ADMIN, 'manage_products') ? 7 : 6} className="text-center">No products found.</CTableDataCell>
                  </CTableRow>
                ) : (
                  paginatedProducts.map((product) => (
                    <CTableRow key={product._id}>
                      <CTableDataCell>{product._id}</CTableDataCell>
                      <CTableDataCell>{product.name}</CTableDataCell>
                      <CTableDataCell>
                        {(() => {
                          if (product.category_id && typeof product.category_id === 'object' && product.category_id.name) {
                            return product.category_id.name;
                          }
                          if (product.category_id && categories.length > 0) {
                            const found = categories.find(cat => cat._id === product.category_id || cat._id === product.category_id._id);
                            return found ? found.name : '-';
                          }
                          return '-';
                        })()}
                      </CTableDataCell>
                      <CTableDataCell>
                        {(() => {
                          // Support base64, URL, and data URL string in 'image' field
                          if (product.images && product.images.length > 0 && product.images[0]) {
                            const imgObj = product.images[0];
                            // If backend returns a direct URL
                            if (typeof imgObj === 'string' && imgObj.startsWith('http')) {
                              return (
                                <img
                                  src={imgObj}
                                  alt="Product"
                                  style={{ width: '40px', height: '40px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #ccc' }}
                                />
                              );
                            }
                            // If backend returns { url: ... }
                            if (imgObj.url && typeof imgObj.url === 'string' && imgObj.url.startsWith('http')) {
                              return (
                                <img
                                  src={imgObj.url}
                                  alt="Product"
                                  style={{ width: '40px', height: '40px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #ccc' }}
                                />
                              );
                            }
                            // If backend returns { image: { contentType, base64 } }
                            if (imgObj.image && imgObj.image.contentType && imgObj.image.base64) {
                              return (
                                <img
                                  src={`data:${imgObj.image.contentType};base64,${imgObj.image.base64}`}
                                  alt="Product"
                                  style={{ width: '40px', height: '40px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #ccc' }}
                                />
                              );
                            }
                            // If backend returns { image: 'data:image/jpeg;base64,...' }
                            if (imgObj.image && typeof imgObj.image === 'string' && imgObj.image.startsWith('data:image')) {
                              return (
                                <img
                                  src={imgObj.image}
                                  alt="Product"
                                  style={{ width: '40px', height: '40px', objectFit: 'cover', borderRadius: '4px', border: '1px solid #ccc' }}
                                />
                              );
                            }
                            // Log for debugging if none of the above
                            console.warn('Unknown image object structure:', imgObj);
                          }
                          return <span className="text-muted">No image</span>;
                        })()}
                      </CTableDataCell>
                      <CTableDataCell>
                        {product.variants && product.variants.length > 0
                          ? `$${product.variants[0].price}`
                          : '-'}
                      </CTableDataCell>
                      <CTableDataCell>
                        {product.variants && product.variants.length > 0
                          ? product.variants[0].stock_qty
                          : '-'}
                      </CTableDataCell>
                      {(hasPermission('admin', 'manage_products') || hasPermission('super_admin', 'manage_products') || hasPermission('product_manager', 'manage_products')) && (
                        <CTableDataCell>
                          <CButton
                            color="info"
                            size="sm"
                            className="me-2"
                            onClick={() => navigate(`/products/${product._id}`)}
                          >
                            View Product
                          </CButton>
                          <CButton color="danger" size="sm" onClick={() => handleDelete(product._id)}>
                            Delete
                          </CButton>
                        </CTableDataCell>
                      )}
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
              {[...Array(totalFilteredPages)].map((_, idx) => (
                <CPaginationItem
                  key={idx + 1}
                  active={currentPage === idx + 1}
                  onClick={() => handlePageChange(idx + 1)}
                >
                  {idx + 1}
                </CPaginationItem>
              ))}
              <CPaginationItem
                disabled={currentPage === totalFilteredPages || totalFilteredPages === 0}
                onClick={() => handlePageChange(currentPage + 1)}
              >
                Next
              </CPaginationItem>
            </CPagination>
          </>
        )}
      </CCardBody>
    </CCard>
  );
};

export default ProductList;