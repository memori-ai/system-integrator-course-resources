# Advanced Functions with AIsuru

> Complete guide to creating and integrating advanced functions to extend your AIsuru agent capabilities

## 🎯 Overview

This guide covers how to create advanced functions that enable your AIsuru agents to interact with external REST APIs and services. You'll learn how to:

- Create custom functions that fetch real-time data from external APIs
- Configure webhooks and HTTP parameters
- Auto-generate multiple functions from OpenAPI/Swagger specifications
- Link functions to your agents and configure their usage
- Debug and verify function calls in conversations

## 🚀 Try the Demos

This module includes **two live demo applications** that showcase different approaches to creating and using advanced functions.

### Running the Demos

```bash
# Navigate to the demo folder
cd demo

# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:3000
```

### Demo 1: Connecting Agents to REST Services

Learn how to connect your agent to external REST APIs using a weather data example.

- Create an advanced function in AIsuru platform
- Configure webhook URL and HTTP parameters
- Use template variables for dynamic data
- Link the function to your agent
- Test and verify API calls in conversations

**Use case:** Agents that need to fetch real-time data from external services (weather, stock prices, news, etc.)

### Demo 2: Using Swagger Files

Learn how to auto-generate multiple functions from OpenAPI/Swagger specifications.

- Download and prepare Swagger/OpenAPI files
- Import specifications into AIsuru
- Auto-generate multiple functions at once
- Review and select relevant functions
- Configure and test imported functions

**Use case:** Quickly integrate complex APIs with existing documentation

📁 **Demo Source Code**: [demo/](./demo/)

---

## 📋 Prerequisites

Before starting, you need:

1. An **AIsuru account** at [aisuru.com](https://www.aisuru.com)
2. A configured **AI Agent (Memori)** in your account
3. Access to the **Advanced Functions** section in your agent settings
4. Basic knowledge of REST APIs and HTTP methods

---

## 🔧 Creating Your First Advanced Function

### Step 1: Navigate to Advanced Functions

In your AIsuru agent dashboard:
1. Click on **Advanced Functions** in the left sidebar
2. Click **Create New Function**

### Step 2: Configure the Function

Fill in the function details:

| Field | Description | Example |
|-------|-------------|---------|
| **Nome** (Name) | Function identifier | `FUNZIONE_RECUPERA_DATI_METEO` |
| **Descrizione** (Description) | What the function does | "Retrieves weather information for a specific city" |
| **Webhook URL** | External API endpoint | `https://api.open-meteo.com/v1/forecast` |
| **Metodo HTTP** | HTTP method | `GET` or `POST` |

### Step 3: Configure Parameters

Use template variables in your query string or request body:

```
latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation&forecast_days=3
```

**Template Variables:**
- Use `{variable_name}` format
- The agent will populate these based on user requests
- Variables must be explained in the agent's prompt

### Step 4: Link to Your Agent

1. Go to **Agent Settings → Advanced Functions**
2. Add your newly created function
3. Save the configuration

### Step 5: Update Agent Prompt

Instruct your agent on how to use the function in the prompt:

```
You are a weather assistant. When users ask about weather:
1. Extract the city name from the request
2. Determine latitude and longitude coordinates
3. Use FUNZIONE_RECUPERA_DATI_METEO with lat and lon parameters
4. Present the weather information clearly
```

---

## 📊 Using OpenAPI/Swagger Files

### Why Use Swagger Files?

OpenAPI (Swagger) specifications offer several advantages:

- ✅ **Automatic generation**: Create multiple functions at once
- ✅ **Consistency**: All endpoints and parameters are standardized
- ✅ **Time-saving**: Perfect for complex APIs with many endpoints
- ✅ **Accuracy**: Uses official API specifications

### Importing a Swagger File

1. **Obtain the Swagger/OpenAPI file**
   - Download from the API documentation
   - Or export from your own API

2. **Navigate to Advanced Functions**
   - Click on **"Converti OpenAPI in funzioni"** (Convert OpenAPI to functions)

3. **Configure the import**
   - **Base webhook URL**: e.g., `https://engine.memori.ai`
   - **Upload file**: Select your `.json` or `.yaml` file

4. **Review generated functions**
   - AIsuru creates one function per API endpoint
   - Each function includes parameters and descriptions
   - Select which functions to enable

5. **Link to agents**
   - Add relevant functions to your agents
   - Update prompts to explain when to use each function

---

## 🔐 Testing Your Agent

### Getting Your Agent Credentials

Navigate to your agent in AIsuru, then click on **Dev docs** in the left sidebar.

You'll find:

| Field | Location | Example |
|-------|----------|---------|
| **Memori (Agent) ID** | Main section | `a1b2c3d4-e5f6-7890-abcd-ef1234567890` |
| **Owner user ID** | ▼ Other references | `c3d4e5f6-a7b8-9012-cdef-123456789012` |
| **Engine URL** | Main section | `https://engine.memori.ai/memori/v2` |
| **Backend URL** | Main section | `https://backend.memori.ai/api/v2` |

### Testing in the Web Component

Use these credentials to configure the web component in the demo applications:

```html
<memori-client
  memoriName="YourAgentName"
  ownerUserName="your.username"
  memoriID="YOUR_MEMORI_ID"
  ownerUserID="YOUR_OWNER_USER_ID"
  tenantID="www.aisuru.com"
  engineURL="https://engine.memori.ai/memori/v2"
  apiURL="https://backend.memori.ai/api/v2"
  baseURL="https://www.aisuru.com"
  layout="CHAT"
  uiLang="EN"
  spokenLang="EN"
  showLogin="true"
></memori-client>
```

---

## 🎛️ Advanced Function Configuration

### JSON Function Structure

When creating advanced functions, AIsuru stores them in this format:

```json
{
  "name": "GET_WEATHER_DATA_FUNCTION",
  "description": "Retrieves weather information for specific coordinates",
  "webhook": "https://api.open-meteo.com/v1/forecast",
  "method": "GET",
  "queryParams": "latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation",
  "headers": {},
  "bodyTemplate": null,
  "timeout": 30000
}
```

### Supported HTTP Parameters

#### Query Parameters (GET)

Add parameters in the query string:

```
?param1={var1}&param2={var2}&param3=fixed_value
```

**Example:**
```
?city={city_name}&units=metric&appid=your_api_key
```

#### Request Body (POST/PUT)

For POST/PUT requests, use the body template in JSON format:

```json
{
  "query": "{user_query}",
  "filters": {
    "category": "{category}",
    "limit": 10
  }
}
```

#### Custom Headers

Configure headers for authentication and content-type:

```
Authorization: Bearer {api_token}
Content-Type: application/json
X-Custom-Header: value
```

**Security notes:**
- Never include API keys in the agent prompt
- Use the Headers section in function settings
- For production, use environment variables or vaults

### Template Variables

Template variables follow the `{variable_name}` format:

| Variable | Description | Example value |
|----------|-------------|---------------|
| `{query}` | Complete user query | "Search hotels in Rome" |
| `{city}` | Extracted city name | "Rome" |
| `{date}` | Extracted date | "2024-03-15" |
| `{user_id}` | User ID (if authenticated) | "user_12345" |

**The agent automatically populates these variables** based on:
1. User input
2. Conversation context
3. System prompt instructions

---

## 📡 REST Function Schema

### Anatomy of a Function Call

```
1. User Input
   ↓
2. Agent analyzes and extracts parameters
   ↓
3. Populates template with variables
   ↓
4. Sends HTTP request to endpoint
   ↓
5. Receives API response
   ↓
6. Processes and presents data to user
```

### Request Format

**GET Request:**
```http
GET /v1/forecast?latitude=41.9&longitude=12.5&hourly=temperature_2m HTTP/1.1
Host: api.open-meteo.com
User-Agent: AIsuru-Agent/1.0
```

**POST Request:**
```http
POST /v1/search HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer abc123

{
  "query": "hotels Rome",
  "filters": {
    "stars": 4,
    "price_max": 150
  }
}
```

### Response Format

AIsuru supports standard JSON responses:

**Success (200-299):**
```json
{
  "status": "success",
  "data": {
    "temperature": 22.5,
    "humidity": 65,
    "forecast": [...]
  }
}
```

**Error (400-599):**
```json
{
  "status": "error",
  "message": "Missing parameter: latitude",
  "code": "MISSING_PARAMETER"
}
```

The agent receives **the entire response** and can:
- Extract relevant data
- Handle errors
- Format output for the user

---

## ⚙️ Error Handling and Timeouts

### Timeout Configuration

Configure custom timeouts in function settings:

| Timeout | Recommended Use |
|---------|-----------------|
| 5-10s | Fast APIs (geocoding, cache) |
| 10-30s | Standard APIs (weather, news) |
| 30-60s | Slow APIs (data processing, ML) |

**Default:** 30 seconds

### Handling Errors in the Agent

Instruct the agent in the prompt on how to handle failures:

```
When calling GET_WEATHER_DATA_FUNCTION:

IF the function returns an error:
- Inform the user politely
- Suggest alternatives (e.g., "Try a nearby city")
- Don't show technical details to the user

IF timeout:
- Say: "The weather service is taking longer than usual, please try again shortly"

IF 404/Not Found:
- Say: "I couldn't find weather information for that location"
- Ask to verify spelling or try a nearby city
```

### Common HTTP Status Codes

| Code | Meaning | Agent Action |
|------|---------|--------------|
| 200-299 | Success | Process and present data |
| 400 | Bad Request | Check request parameters |
| 401 | Unauthorized | Verify authentication |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limit, retry later |
| 500-599 | Server Error | Service temporarily unavailable |

### Retry Logic

For critical APIs, instruct the agent to retry:

```
If the function call fails with 500 or timeout:
1. Wait 2 seconds
2. Retry once
3. If it fails again, inform user of temporary issue
```

---

## 🐛 Debugging Function Calls

### Using the Debug View

After testing your agent, verify function calls:

1. Navigate to **"Conversazioni"** (Conversations) in your AIsuru dashboard
2. Find the conversation where the function was called
3. Look for the **red bug icon** 🐛 next to the agent's response
4. Click it to see:
   - Request parameters sent to the API
   - HTTP status code
   - Complete response data
   - Error messages (if any)

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Function not called | Agent doesn't understand when to use it | Update prompt with clearer instructions |
| Missing parameters | Template variables not populated | Ensure agent extracts required data from user input |
| HTTP errors (4xx/5xx) | Invalid API request | Check webhook URL, parameters, and authentication |
| Empty response | API returned no data | Verify API endpoint and parameters are correct |

---

## 💡 Best Practices

### Function Design

- **Clear naming**: Use descriptive function names (e.g., `GET_WEATHER_DATA` not `FUNC1`)
- **Specific purpose**: Each function should do one thing well
- **Error handling**: Consider what happens when APIs fail
- **Documentation**: Write clear descriptions for each function

### Agent Configuration

- **Explicit instructions**: Tell the agent exactly when to use each function
- **Parameter extraction**: Explain how to extract parameters from user input
- **Response formatting**: Instruct how to present API data to users
- **Fallback behavior**: Define what to do when functions fail

### Testing Strategy

1. **Start simple**: Test with known inputs first
2. **Check debug view**: Always verify function calls
3. **Test edge cases**: Try invalid inputs, API failures, etc.
4. **Monitor conversations**: Review how users interact with functions

---

## 📝 Complete Example: Weather Function

Here's a complete example from creation to testing:

### 1. Create the Function

```
Nome: FUNZIONE_RECUPERA_DATI_METEO
Descrizione: Retrieves weather forecast for a city
Webhook: https://api.open-meteo.com/v1/forecast
Metodo: GET
Query String: latitude={lat}&longitude={lon}&hourly=temperature_2m,precipitation&forecast_days=3
```

### 2. Update Agent Prompt

```
You are a helpful weather assistant. When users ask about weather:

1. Extract the city name from their question
2. Use your knowledge to determine the approximate latitude and longitude
3. Call FUNZIONE_RECUPERA_DATI_METEO with the coordinates
4. Present the temperature and precipitation forecast in a friendly way

Example:
User: "What's the weather in Rome?"
You: [Extract city: Rome → Coordinates: lat=41.9, lon=12.5 → Call function → Present results]
"In Rome, the current temperature is 22°C with a 30% chance of rain today..."
```

### 3. Test the Agent

```
User: "What's the weather in London?"
Expected: Agent calls function with lat≈51.5, lon≈-0.1 and returns forecast
```

### 4. Verify in Debug View

Check that:
- ✅ Function was called
- ✅ Parameters were correct (lat and lon)
- ✅ API returned 200 OK
- ✅ Response contains weather data

---

## 🎨 Advanced Techniques

### Chaining Functions

Call multiple functions in sequence:

```
1. GET_CITY_COORDINATES (city_name) → returns {lat, lon}
2. GET_WEATHER_DATA (lat, lon) → returns weather
3. GET_TIMEZONE (lat, lon) → returns timezone
```

### Context-Aware Functions

Use conversation context to populate parameters:

```
User: "I'm in Milan"
Agent: [stores location context]
User: "What's the weather?"
Agent: [uses Milan from context → calls weather function]
```

### Authentication Headers

For APIs requiring authentication:

```
Headers:
Authorization: Bearer {api_key}
X-API-Key: {api_key}
```

Configure these in the function settings, not in the agent prompt.

---

## 🔗 Resources

- [AIsuru Documentation](https://docs.aisuru.com/)
- [Advanced Functions Guide](https://docs.aisuru.com/advanced-functions)
- [API Reference](https://docs.aisuru.com/api-reference)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Web Component NPM Package](https://www.npmjs.com/package/@memori.ai/memori-webcomponent)

---

📚 [Back to SYS-04 Module](../README.md) | 🏠 [Course Home](../../README.md)
