import './App.css'
import React, { useState } from 'react'

function App() {
 const [data,setData] = useState<string>("")
 const HandlerChange =(e:React.ChangeEvent<HTMLTextAreaElement>)=>{
  // console.log(e.target.value)
  setData(e.target.value)
 }
 const HandlerClick = () =>{
  console.log(data)
 }
  return (
    <>
      <div className='txts'>
        <textarea className='entrada' onChange={HandlerChange}></textarea>
        <textarea className='salida' id="" readOnly></textarea>
      </div>
      <div className='btn'>
        <button className='btn_accept' onClick={HandlerClick}>Analizar</button>
      </div>
    </>
  )
}

export default App
