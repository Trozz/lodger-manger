#!/bin/bash

# Lodger Management System - Docker Hub Deployment Script
# This script builds and pushes Docker images to Docker Hub

set -e  # Exit on error

echo "🐳 Lodger Management System - Docker Hub Deployment"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKEND_IMAGE="nowkillkennys/lodger-manager-backend"
FRONTEND_IMAGE="nowkillkennys/lodger-manager-frontend"
VERSION="v1.1.0"
LATEST="latest"
AMD64="amd64"
PLATFORM="linux/amd64"

echo -e "${BLUE}📋 Configuration:${NC}"
echo "  Backend Image: $BACKEND_IMAGE"
echo "  Frontend Image: $FRONTEND_IMAGE"
echo "  Version: $VERSION"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker is installed${NC}"

# Check if logged into Docker Hub
if ! docker info 2>/dev/null | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  Not logged into Docker Hub${NC}"
    echo "Please login first:"
    echo "  docker login"
    exit 1
fi

echo -e "${GREEN}✅ Logged into Docker Hub${NC}"
echo ""

# Build backend image
echo -e "${BLUE}🔨 Building backend image...${NC}"
docker build --platform $PLATFORM -t $BACKEND_IMAGE:$LATEST ./backend
docker build --platform $PLATFORM -t $BACKEND_IMAGE:$VERSION ./backend
docker build --platform $PLATFORM -t $BACKEND_IMAGE:$AMD64 ./backend
echo -e "${GREEN}✅ Backend image built${NC}"

# Build frontend image
echo -e "${BLUE}🔨 Building frontend image...${NC}"
docker build --platform $PLATFORM -t $FRONTEND_IMAGE:$LATEST ./frontend
docker build --platform $PLATFORM -t $FRONTEND_IMAGE:$VERSION ./frontend
docker build --platform $PLATFORM -t $FRONTEND_IMAGE:$AMD64 ./frontend
echo -e "${GREEN}✅ Frontend image built${NC}"
echo ""

# Push images
echo -e "${BLUE}📤 Pushing images to Docker Hub...${NC}"

echo "Pushing backend images..."
docker push $BACKEND_IMAGE:$LATEST
docker push $BACKEND_IMAGE:$VERSION
docker push $BACKEND_IMAGE:$AMD64

echo "Pushing frontend images..."
docker push $FRONTEND_IMAGE:$LATEST
docker push $FRONTEND_IMAGE:$VERSION
docker push $FRONTEND_IMAGE:$AMD64

echo -e "${GREEN}✅ All images pushed successfully${NC}"
echo ""

# Verify images
echo -e "${BLUE}🔍 Verifying published images...${NC}"
echo "Backend images:"
docker search $BACKEND_IMAGE | head -5
echo ""
echo "Frontend images:"
docker search $FRONTEND_IMAGE | head -5
echo ""

# Display usage instructions
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "===================="
echo ""
echo -e "${BLUE}📚 Usage Instructions:${NC}"
echo ""
echo "1. ${YELLOW}For local deployment:${NC}"
echo "   docker-compose up -d"
echo ""
echo "2. ${YELLOW}For production deployment:${NC}"
echo "   # Update your docker-compose.yml to use published images"
echo "   # Or use the Portainer stack configuration from README.md"
echo ""
echo "3. ${YELLOW}For cloud deployment:${NC}"
echo "   # Use the published images in your cloud platform"
echo "   # Images: $BACKEND_IMAGE:$VERSION and $FRONTEND_IMAGE:$VERSION"
echo ""
echo -e "${BLUE}🔗 Image URLs:${NC}"
echo "  Backend:  https://hub.docker.com/r/$BACKEND_IMAGE"
echo "  Frontend: https://hub.docker.com/r/$FRONTEND_IMAGE"
echo ""
echo -e "${GREEN}Happy deploying! 🚀${NC}"