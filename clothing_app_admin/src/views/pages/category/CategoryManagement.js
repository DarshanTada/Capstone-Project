import React, { useState, useEffect } from 'react';
import { CCard, CCardBody, CCardHeader, CForm, CFormInput, CButton, CAlert, CTable } from '@coreui/react';
import axios from 'axios';

const CategoryManagement = () => {
    const [categories, setCategories] = useState([]);
    const [name, setName] = useState('');
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    useEffect(() => {
        fetchCategories();
    }, []);

    const fetchCategories = async () => {
        try {
            const res = await axios.get('http://localhost:3001/api/category/getCategory');
            setCategories(res.data.data || []);
        } catch {
            setCategories([]);
        }
    };

    const handleAddCategory = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');
        if (!name.trim()) {
            setError('Category name is required');
            return;
        }
        try {
            const res = await axios.post('http://localhost:3001/api/category/createCategory', { name });
            if (res.data.success) {
                setSuccess('Category added successfully!');
                setName('');
                fetchCategories();
                setTimeout(() => setSuccess(''), 2000); // Hide success after 2 seconds
            } else {
                setError(res.data.message || 'Failed to add category');
            }
        } catch {
            setError('Failed to add category');
        }
    };

    const handleDeleteCategory = async (id) => {
        setError('');
        setSuccess('');
        try {
            const res = await axios.delete(`http://localhost:3001/api/category/deleteCategory/${id}`);
            if (res.data.success) {
                setSuccess('Category deleted successfully!');
                fetchCategories();
                setTimeout(() => setSuccess(''), 2000); // Hide success after 2 seconds
            } else {
                setError(res.data.message || 'Failed to delete category');
            }
        } catch {
            setError('Failed to delete category');
        }
    };

    return (
        <CCard className="mb-4">
            <CCardHeader><strong>Category Management</strong></CCardHeader>
            <CCardBody>
                {error && <CAlert color="danger">{error}</CAlert>}
                {success && <CAlert color="success">{success}</CAlert>}
                <CForm onSubmit={handleAddCategory} className="mb-4">
                    <CFormInput
                        label="Category Name"
                        value={name}
                        onChange={e => setName(e.target.value)}
                        required
                        className="mb-2"
                    />
                    <CButton color="primary" type="submit">Add Category</CButton>
                </CForm>
                <h5>All Categories</h5>
                <CTable bordered>
                    <thead>
                        <tr><th>Name</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        {categories.map(cat => (
                            <tr key={cat._id}>
                                <td>{cat.name}</td>
                                <td>
                                    <CButton color="danger" size="sm" onClick={() => handleDeleteCategory(cat._id)}>Delete</CButton>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </CTable>
            </CCardBody>
        </CCard>
    );
};

export default CategoryManagement;
