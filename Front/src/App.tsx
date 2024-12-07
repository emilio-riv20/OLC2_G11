import './App.css';
import React, { useState } from 'react';
// @ts-ignore
import parse from './grammar'; // Asegúrate de que la ruta sea correcta

function App() {
    const [data, setData] = useState<string>(""); // Entrada del usuario
    const [output, setOutput] = useState<string>(""); // Salida del análisis

    const HandlerChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
        setData(e.target.value); // Actualiza el estado con la entrada del usuario
    };

    const HandlerClick = () => {
        try {
            const result = parse(data); // Analiza la entrada con Peggy
            setOutput(`Todo bien!`); // Resultado exitoso
        } catch (error: any) {
            setOutput(`Error: ${error.message}`); // Mensaje de error
        }
    };

    return (
        <>
            <div className="txts">
                <textarea
                    className="entrada"
                    onChange={HandlerChange}
                    placeholder="Escribe tu gramática aquí"
                ></textarea>
                <textarea
                    className="salida"
                    value={output}
                    readOnly
                    placeholder="Resultados del análisis"
                ></textarea>
            </div>
            <div className="btn">
                <button className="btn_accept" onClick={HandlerClick}>
                    Analizar
                </button>
            </div>
        </>
    );
}

export default App;
