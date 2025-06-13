// Example: src/components/ProductUpload.js
import React from 'react'
import Papa from 'papaparse'
import * as XLSX from 'xlsx'
import { CCard, CCardBody, CCardHeader, CButton, CFormInput } from '@coreui/react'

const ProductUpload = ({ onDataParsed, accept }) => {
  const handleFileChange = (e) => {
    const file = e.target.files[0]
    if (!file) return

    const fileExt = file.name.split('.').pop().toLowerCase()
    if (fileExt === 'csv') {
      Papa.parse(file, {
        header: true,
        complete: (results) => {
          onDataParsed(results.data)
        },
      })
    } else if (fileExt === 'xls' || fileExt === 'xlsx') {
      const reader = new FileReader()
      reader.onload = (evt) => {
        const data = new Uint8Array(evt.target.result)
        const workbook = XLSX.read(data, { type: 'array' })
        const sheetName = workbook.SheetNames[0]
        const worksheet = workbook.Sheets[sheetName]
        const json = XLSX.utils.sheet_to_json(worksheet)
        onDataParsed(json)
      }
      reader.readAsArrayBuffer(file)
    } else {
      alert('Unsupported file type. Please upload a CSV or XLS/XLSX file.')
    }
  }

  return (
    <CCard className="mb-4">
      <CCardHeader>Upload Products (CSV/XLS/XLSX)</CCardHeader>
      <CCardBody>
        <CFormInput
          type="file"
          accept={accept || ".csv,.xls,.xlsx"}
          onChange={handleFileChange}
        />
      </CCardBody>
    </CCard>
  )
}

export default ProductUpload