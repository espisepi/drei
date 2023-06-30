#!/bin/sh
set -ex

PORT=5188

yarn build
(cd dist && npm pack)

kill_app() {
  kill $(lsof -ti:$PORT)
}

kill_app || echo "ok, no previous running process on port $PORT"

#
# ██╗   ██╗██╗████████╗███████╗
# ██║   ██║██║╚══██╔══╝██╔════╝
# ██║   ██║██║   ██║   █████╗  
# ╚██╗ ██╔╝██║   ██║   ██╔══╝  
#  ╚████╔╝ ██║   ██║   ███████╗
#   ╚═══╝  ╚═╝   ╚═╝   ╚══════╝
#

rm -rf e2e/viteapp

# Vite
(cd e2e; npm create vite@latest viteapp -- --template react)

# drei
(cd e2e/viteapp; npm i; npm i ../../dist/react-three-drei-0.0.0-semantic-release.tgz)

# App.jsx
cp e2e/App.jsx e2e/viteapp/src/App.jsx

# npm run dev + jest
(cd e2e/viteapp; npm run dev -- --port $PORT &)
npx jest e2e/snapshot.test.js || kill_app
kill_app

rm -rf e2e/viteapp

#
# ███╗   ██╗███████╗██╗  ██╗████████╗
# ████╗  ██║██╔════╝╚██╗██╔╝╚══██╔══╝
# ██╔██╗ ██║█████╗   ╚███╔╝    ██║   
# ██║╚██╗██║██╔══╝   ██╔██╗    ██║   
# ██║ ╚████║███████╗██╔╝ ██╗   ██║   
# ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝   
#

rm -rf e2e/nextapp

# Vite
(cd e2e; npx create-next-app@latest nextapp --js --eslint --no-tailwind --no-src-dir --app --import-alias "@/*")

# drei
(cd e2e/nextapp; npm i; npm i ../../dist/react-three-drei-0.0.0-semantic-release.tgz)

# App.jsx
cp e2e/App.jsx e2e/nextapp/app/page.js

# npm run dev + jest
(cd e2e/nextapp; npm run dev -- --port $PORT &)
npx jest e2e/snapshot.test.js || kill_app
kill_app

rm -rf e2e/nextapp

#
#  ██████╗██████╗  █████╗ 
# ██╔════╝██╔══██╗██╔══██╗
# ██║     ██████╔╝███████║
# ██║     ██╔══██╗██╔══██║
# ╚██████╗██║  ██║██║  ██║
#  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝
#

rm -rf e2e/craapp

# CRA
(cd e2e; npx create-react-app craapp)

# drei
(cd e2e/craapp; npm i ../../dist/react-three-drei-0.0.0-semantic-release.tgz)

# App.jsx
cp e2e/App.jsx e2e/craapp/src/App.js

# npm run dev + jest
(cd e2e/craapp; PORT=$PORT BROWSER=none npm start &)
npx jest e2e/snapshot.test.js || kill_app
kill_app

rm -rf e2e/craapp

echo "✅ e2e ok"