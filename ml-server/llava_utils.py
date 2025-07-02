import requests
import json

def query_llava(prompt: str, system: str = "", image: str = None):
    try:
        payload = {
            "model": "llava",
            "prompt": prompt,
            "system": system or "",
            "images": [image] if image else [],
        }

        response = requests.post(
            "http://localhost:11434/api/generate",
            json=payload,
            stream=True,
            timeout=120
        )

        final_output = ""
        for line in response.iter_lines():
            if line:
                try:
                    data = json.loads(line.decode("utf-8"))
                    final_output += data.get("response", "")
                except:
                    continue

        return {"response": final_output.strip()}

    except Exception as e:
        return {"error": f"LLaVA failed: {str(e)}"}
