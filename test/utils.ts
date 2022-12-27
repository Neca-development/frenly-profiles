export const base64ToJSON = (encoded_target_json: string) => {
    return JSON.parse(atob(encoded_target_json.replace(/^data:\w+\/\w+;base64,/, '')))
}
export const base64ToString = (encoded_target_json: string) => {
    
    
    return atob(encoded_target_json.replace("data:image/svg+xml;base64,", ""))
}