# system-integrator-course-resources

## Quick Start

```bash
# Navigate to the demo folder
cd web_component/demo
```

Create a file named `.env_dev` in the `demo/` folder (first time only) with the following content:

```
MONGO_URI=mongodb://mongodb:27017/sys_05_web_component_development
```

```bash
# Build and start the application (single command)
npm run start

# Open in your browser
open http://localhost:3000
```

> 💡 **Windows users — if `npm run start` fails:** Git on Windows may convert line endings to CRLF, which breaks shell scripts inside Docker. Run this command once in your terminal and then retry:
> ```bash
> git config --global core.autocrlf false
> ```
