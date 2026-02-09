import fetch from 'node-fetch';

const url = 'https://inviting-eminent-piglet.ngrok-free.app/mcp';

console.log(`Testing SSE connection to: ${url}`);

try {
  const response = await fetch(url);
  console.log('Status:', response.status);
  console.log('Headers:', Object.fromEntries(response.headers));
  
  const reader = response.body;
  let data = '';
  
  // Read first chunk
  for await (const chunk of reader) {
    data += chunk.toString();
    console.log('\nReceived data:');
    console.log(data);
    
    // Stop after first event
    if (data.includes('endpoint')) {
      break;
    }
  }
} catch (error) {
  console.error('Error:', error.message);
}
