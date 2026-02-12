# TDD 기반 마이크로 학습 로드맵

**세션 ID**: `start_20260213_015416`
**기술 스택**: Vue.js 3, Spring Boot, MyBatis, Oracle
**학습 목표**: CRUD 애플리케이션 구현
**학습 방식**: TDD (Test-Driven Development)

---

## 📋 전체 아키텍처 개요 (고급 기능 포함)

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│  Vue.js 3   │◄───────►│  Spring Boot│◄───────►│   Oracle DB │
│  (프론트엔드)│  Axios  │  (백엔드 API)│  MyBatis │   (데이터베이스)│
└─────────────┘         └─────────────┘         └─────────────┘
                              │
                              ├── Partition by (데이터 분할)
                              ├── 다중 조인 (Multiple Joins)
                              └── 동시성 제어 (Concurrency Control)
```

---

## 🎯 학습 단계 (Micro-Steps)

### Phase 1: 시스템 아키텍처 이해
**목표**: 전체 시스템 구조와 데이터 흐름 이해

#### Step 1.1: 프로젝트 구조 설계
- **학습 내용**: MVC 패턴, Layered Architecture 이해
- **확인 방법**: `.sisyphus/evidence/phase1/step1.1/architecture-diagram.md` 생성
- **명령**:
  ```bash
  mkdir -p .sisyphus/evidence/phase1/step1.1
  echo "# [TODO] 아키텍처 다이어그램 작성" > .sisyphus/evidence/phase1/step1.1/architecture-diagram.md
  ```

#### Step 1.2: 기술 스택 역할 정의
- **학습 내용**: 각 기술의 역할과 통합 방식
- **확인 방법**: `.sisyphus/evidence/phase1/step1.2/tech-stack-roles.md` 생성
- **명령**:
  ```bash
  mkdir -p .sisyphus/evidence/phase1/step1.2
  echo "# [TODO] 각 기술 스택의 역할 정의" > .sisyphus/evidence/phase1/step1.2/tech-stack-roles.md
  ```

---

### Phase 2: 개발 환경 구축 (Docker Compose)
**목표**: Node.js, Java, Oracle DB 통합 구축
**⏱️ 예상 시간**: 30분

#### Step 2.1: Docker Compose 설정 파일 생성
- **학습 내용**: `docker-compose.yml` 구성, 서비스 정의
- **확인 방법**: `docker-compose.yml` 파일 생성 확인
- **명령**:
  ```bash
  mkdir -p backend frontend
  cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  oracle-db:
    image: gvenzl/oracle-xe:21-slim
    container_name: oracle-db
    environment:
      - ORACLE_PASSWORD=oracle
      - ORACLE_DATABASE=learning_db
    ports:
      - "1521:1521"
    volumes:
      - oracle-data:/opt/oracle/oradata
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "echo 'SELECT 1 FROM DUAL;' | sqlplus -s system/oracle@localhost:1521/learning_db || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 5
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: spring-backend
    depends_on:
      oracle-db:
        condition: service_healthy
    environment:
      - SPRING_DATASOURCE_URL=jdbc:oracle:thin:@oracle-db:1521:learning_db
      - SPRING_DATASOURCE_USERNAME=system
      - SPRING_DATASOURCE_PASSWORD=oracle
    ports:
      - "8080:8080"
    networks:
      - app-network
    volumes:
      - ./backend:/app
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: vue-frontend
    ports:
      - "5173:5173"
    networks:
      - app-network
    volumes:
      - ./frontend:/app
      - /app/node_modules
networks:
  app-network:
    driver: bridge
volumes:
  oracle-data:
EOF
cat docker-compose.yml
  ```

#### Step 2.2: Oracle DB 컨테이너 실행 및 검증
- **학습 내용**: Docker Compose 실행, Oracle DB 연결 테스트
- **확인 방법**: `docker ps`로 컨테이너 실행 확인, Oracle 접속 테스트
- **명령**:
  ```bash
  # Oracle DB 컨테이너 실행
  docker-compose up -d oracle-db
  
  # 컨테이너 상태 확인
  docker ps
  
  # Oracle DB 접속 테스트
  docker exec -it oracle-db sqlplus system/oracle@localhost:1521/learning_db << 'EOF'
  SELECT * FROM DUAL;
  EXIT;
  EOF
  
  # Oracle DB 버전 확인
  docker exec oracle-db sqlplus -v
  ```

---

### Phase 3: Spring Boot 백엔드 구현
**목표**: REST API 서버 구축
**⏱️ 예상 시간**: 45분

#### Step 3.1: Spring Boot 프로젝트 생성 (Maven)
- **학습 내용**: Spring Initializr, Maven 구성, 의존성 설정
- **확인 방법**: `pom.xml` 파일 생성 및 구조 확인
- **명령**:
  ```bash
  mkdir -p backend/src/main/java/com/example/demo backend/src/main/resources
  
  cat > backend/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>
    
    <groupId>com.example</groupId>
    <artifactId>spring-demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>spring-demo</name>
    <description>Demo project for Spring Boot</description>
    
    <properties>
        <java.version>17</java.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>3.0.3</version>
        </dependency>
        <dependency>
            <groupId>com.oracle.database.jdbc</groupId>
            <artifactId>ojdbc11</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF
  
  # pom.xml 구조 확인
  grep -A 5 "<dependencies>" backend/pom.xml
  ```

#### Step 3.2: Oracle DB 연결 설정
- **학습 내용**: `application.properties`, DataSource 설정
- **확인 방법**: `application.properties` 파일 내용 확인
- **명령**:
  ```bash
  cat > backend/src/main/resources/application.properties << 'EOF'
spring.application.name=spring-demo
server.port=8080

# Oracle DB 설정
spring.datasource.url=jdbc:oracle:thin:@oracle-db:1521:learning_db
spring.datasource.username=system
spring.datasource.password=oracle
spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

# MyBatis 설정
mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.type-aliases-package=com.example.demo.entity
mybatis.configuration.map-underscore-to-camel-case=true
mybatis.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl
EOF
  
  # 설정 확인
  cat backend/src/main/resources/application.properties
  ```

#### Step 3.3: MyBatis 설정
- **학습 내용**: MyBatis-Plus, Mapper 인터페이스, XML 설정
- **확인 방법**: `mybatis-config.xml`, Mapper 인터페이스 생성 확인
- **명령**:
  ```bash
  mkdir -p backend/src/main/resources/mapper backend/src/main/java/com/example/demo/mapper
  
  cat > backend/src/main/resources/mybatis-config.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>
</configuration>
EOF
  
  cat > backend/src/main/java/com/example/demo/mapper/UserMapper.java << 'EOF'
package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    // TODO: UserMapper 메서드 정의
}
EOF
  
  # 설정 확인
  ls -la backend/src/main/resources/mapper/
  ```

#### Step 3.4: Entity, Mapper, Service 레이어 구현 (동시성 제어 포함)
- **학습 내용**: JPA/MyBatis Entity, Mapper, Service 패턴, 동시성 제어 개념
- **확인 방법**: 각 레이어 클래스 생성 확인
- **명령**:
  ```bash
  mkdir -p backend/src/main/java/com/example/demo/{entity,service,controller}
  
  cat > backend/src/main/java/com/example/demo/entity/User.java << 'EOF'
package com.example.demo.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private Long id;
    private String username;
    private String email;
    private String passwordHash;
    private String role;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 동시성 제어를 위한 버전 관리 (Optimistic Locking)
    @Version
    private Long version;
}
EOF
  
  cat > backend/src/main/java/com/example/demo/entity/UserActivityLog.java << 'EOF'
package com.example.demo.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserActivityLog {
    private Long id;
    private Long userId;
    private String actionType;
    private String actionData;
    private String ipAddress;
    private LocalDateTime createdAt;
}
EOF
  
  cat > backend/src/main/java/com/example/demo/entity/UserRole.java << 'EOF'
package com.example.demo.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserRole {
    private Long id;
    private Long userId;
    private String roleName;
    private LocalDateTime grantedAt;
}
EOF
  
  cat > backend/src/main/java/com/example/demo/service/UserService.java << 'EOF'
package com.example.demo.service;

import com.example.demo.entity.User;
import java.util.List;

public interface UserService {
    // 동시성 제어: @Transactional(readOnly = true) 읽기 작업
    List<User> getAllUsers();
    
    // 동시성 제어: @Transactional(isolation = Isolation.SERIALIZABLE) 격리 레벨 설정
    User getUserById(Long id) throws Exception;
    
    // 동시성 제어: @Version을 위한 optimistic locking
    User createUser(User user) throws Exception;
    
    // 동시성 제어: 데이터 무결성 보장
    void updateUser(Long id, User userDetails) throws Exception;
    
    // 동시성 제어: 쿼리 수행 시 FOR UPDATE 사용
    User lockUserForUpdate(Long id) throws Exception;
    
    // 다중 조인: 사용자와 역할 조회
    UserWithRoles getUserWithRoles(Long id) throws Exception;
}
EOF
  
  # 레이어 구조 확인
  find backend/src -name "*.java" -type f
  ```

#### Step 3.5: REST Controller 구현 (동시성 제어 포함)
- **학습 내용**: @RestController, @GetMapping, @PostMapping 등, 동시성 제어 응용
- **확인 방법**: Controller 클래스 생성 확인
- **명령**:
  ```bash
  cat > backend/src/main/java/com/example/demo/controller/UserController.java << 'EOF'
package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import com.example.demo.entity.User;
import com.example.demo.service.UserService;
import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    private final UserService userService;
    
    public UserController(UserService userService) {
        this.userService = userService;
    }
    
    // 동시성 제어: 읽기 작업 (read-only 트랜잭션)
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }
    
    // 동시성 제어: 격리 레벨 설정 (SERIALIZABLE)
    @GetMapping("/{id}")
    public User getUserById(@PathVariable Long id) throws Exception {
        return userService.getUserById(id);
    }
    
    // 동시성 제어: Optimistic Locking 적용
    @PostMapping
    public User createUser(@RequestBody User user) throws Exception {
        return userService.createUser(user);
    }
    
    // 동시성 제어: 데이터 무결성 보장
    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User userDetails) throws Exception {
        return userService.updateUser(id, userDetails);
    }
    
    // 동시성 제어: 쿼리 수행 시 FOR UPDATE 사용
    @GetMapping("/{id}/lock")
    public User lockUserForUpdate(@PathVariable Long id) throws Exception {
        return userService.lockUserForUpdate(id);
    }
    
    // 다중 조인: 사용자와 역할 조회
    @GetMapping("/{id}/with-roles")
    public UserWithRoles getUserWithRoles(@PathVariable Long id) throws Exception {
        return userService.getUserWithRoles(id);
    }
}
EOF
  
  # Controller 확인
  cat backend/src/main/java/com/example/demo/controller/UserController.java
  ```

#### Step 3.6: Spring Boot 애플리케이션 진입점 설정
- **학습 내용**: @SpringBootApplication, 메인 클래스 구현
- **확인 방법**: Main 클래스 생성 확인
- **명령**:
  ```bash
  cat > backend/src/main/java/com/example/demo/DemoApplication.java << 'EOF'
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
EOF
  
  # Main 클래스 확인
  cat backend/src/main/java/com/example/demo/DemoApplication.java
  ```

---

### Phase 4: Oracle DB 스키마 설계
**목표**: 데이터베이스 구조 설계
**⏱️ 예상 시간**: 30분

#### Step 4.1: Entity 설계 (Partition by 적용)
- **학습 내용**: 테이블 설계, 컬럼 정의, 데이터 타입, Partition by 구성
- **확인 방법**: SQL 스크립트 파일 생성
- **명령**:
  ```bash
  cat > backend/src/main/resources/schema.sql << 'EOF'
-- 사용자 활동 로그 테이블 (Partition by Range 적용)
CREATE TABLE user_activity_logs (
    id NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER(10),
    action_type VARCHAR2(20),  -- CREATE, READ, UPDATE, DELETE
    action_data CLOB,
    ip_address VARCHAR2(45),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
) PARTITION BY RANGE (created_at) (
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')),
    PARTITION p_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

-- 사용자 테이블 (기본 테이블)
CREATE TABLE users (
    id NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password_hash VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) DEFAULT 'USER',
    is_active NUMBER(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT valid_email CHECK (email LIKE '%_@__%.__%')
);

-- 사용자와 활동 로그 관계 테이블 (다중 조인용)
CREATE TABLE user_roles (
    id NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER(10) NOT NULL,
    role_name VARCHAR2(20) NOT NULL,
    granted_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_user_roles FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Sequence 생성
CREATE SEQUENCE seq_users START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_user_activity START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_user_roles START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Index 생성
CREATE INDEX idx_user_activity_user_id ON user_activity_logs(user_id);
CREATE INDEX idx_user_activity_created_at ON user_activity_logs(created_at);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);

-- 테이블 설명 추가
COMMENT ON TABLE users IS '사용자 기본 정보 테이블';
COMMENT ON COLUMN users.id IS '사용자 ID (자동 생성)';
COMMENT ON COLUMN users.username IS '사용자 이름 (고유)';
COMMENT ON COLUMN users.email IS '이메일 주소 (고유)';
COMMENT ON COLUMN users.password_hash IS '비밀번호 해시';
COMMENT ON COLUMN users.role IS '사용자 역할';
COMMENT ON COLUMN users.is_active IS '계정 활성화 상태';

COMMENT ON TABLE user_activity_logs IS '사용자 활동 로그 (Partition by Range)';
COMMENT ON TABLE user_roles IS '사용자 역할 관계 테이블';
EOF
  
  # 스크립트 확인
  cat backend/src/main/resources/schema.sql
  ```

#### Step 4.2: 스키마 적용 테스트
- **학습 내용**: SQL 스크립트 실행, 데이터베이스 구조 검증, Partition by 동작 확인
- **확인 방법**: 테이블 생성 확인, Sequence 및 Index 확인, Partition 정보 확인
- **명령**:
  ```bash
  # 스키마 적용 (Docker 컨테이너 내에서)
  docker exec oracle-db sqlplus system/oracle@localhost:1521/learning_db @/opt/oracle/scripts/sql/schema.sql
  
  # 테이블 목록 확인
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 100
  SELECT table_name FROM user_tables ORDER BY table_name;
  EXIT;
  EOF
  
  # Partition by 정보 확인
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 100
  SELECT partition_name, high_value 
  FROM user_tab_partitions 
  WHERE table_name = 'USER_ACTIVITY_LOGS';
  EXIT;
  EOF
  
  # Sequence 확인
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 100
  SELECT sequence_name FROM user_sequences;
  EXIT;
  EOF
  
  # Index 확인
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 100
  SELECT index_name, table_name FROM user_indexes;
  EXIT;
  EOF
  ```

---

### Phase 5: Vue.js 3 프론트엔드 구현
**목표**: 사용자 인터페이스 구축
**⏱️ 예상 시간**: 45분

#### Step 5.1: Vue CLI 프로젝트 생성
- **학습 내용**: Vue 3, Composition API, Vite, npm
- **확인 방법**: `package.json` 파일 생성 확인
- **명령**:
  ```bash
  cat > frontend/package.json << 'EOF'
{
  "name": "vue-frontend",
  "version": "1.0.0",
  "description": "Vue.js 3 CRUD Frontend",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.3.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^4.5.0",
    "vite": "^5.0.0"
  }
}
EOF
  
  # package.json 구조 확인
  cat frontend/package.json
  ```

#### Step 5.2: Axios 설정 및 API 연결
- **학습 내용**: Axios, API 통합, CORS 설정
- **확인 방법**: `api.js` 또는 API 모듈 생성 확인
- **명령**:
  ```bash
  mkdir -p frontend/src/{api,components,views}
  
  cat > frontend/src/api/userApi.js << 'EOF'
import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api/users';

export const userApi = {
  // TODO: CRUD API 메서드 정의
};
EOF
  
  # API 모듈 확인
  cat frontend/src/api/userApi.js
  ```

#### Step 5.3: 메인 컴포넌트 구현
- **학습 내용**: Vue 3 Composition API, Props, Emits, Reactive State
- **확인 방법**: 메인 컴포넌트 파일 생성 확인
- **명령**:
  ```bash
  cat > frontend/src/App.vue << 'EOF'
<template>
  <div id="app">
    <h1>Vue.js 3 CRUD Demo</h1>
    <p>TODO: CRUD 기능 구현</p>
  </div>
</template>

<script setup>
// TODO: Composition API 사용
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  text-align: center;
  margin-top: 60px;
}
</style>
EOF
  
  # App.vue 확인
  cat frontend/src/App.vue
  ```

#### Step 5.4: CRUD 페이지 구현 (동시성 제어 UI 포함)
- **학습 내용**: Create, Read, Update, Delete 구현, 동시성 제어 개념 적용
- **확인 방법**: 각 CRUD 기능 컴포넌트 생성 확인
- **명령**:
  ```bash
  mkdir -p frontend/src/views
  
  cat > frontend/src/views/UserList.vue << 'EOF'
<template>
  <div>
    <h2>사용자 목록</h2>
    <div v-if="loading" class="loading">로딩 중...</div>
    <div v-if="error" class="error">{{ error }}</div>
    <table v-else>
      <thead>
        <tr>
          <th>ID</th>
          <th>Username</th>
          <th>Email</th>
          <th>Role</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id">
          <td>{{ user.id }}</td>
          <td>{{ user.username }}</td>
          <td>{{ user.email }}</td>
          <td>{{ user.role }}</td>
          <td>
            <button @click="deleteUser(user.id)">삭제</button>
          </td>
        </tr>
      </tbody>
    </table>
    <p class="note">동시성 제어: 동시 접속 시 데이터 무결성 보장</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { userApi } from '../api/userApi'

const users = ref([])
const loading = ref(false)
const error = ref(null)

const fetchUsers = async () => {
  try {
    loading.value = true
    users.value = await userApi.getAllUsers()
  } catch (err) {
    error.value = '사용자 목록을 불러오는데 실패했습니다'
  } finally {
    loading.value = false
  }
}

const deleteUser = async (id) => {
  if (!confirm('정말 삭제하시겠습니까?')) return
  
  try {
    loading.value = true
    await userApi.deleteUser(id)
    await fetchUsers()
  } catch (err) {
    error.value = '삭제에 실패했습니다'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchUsers()
})
</script>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}
th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}
button {
  padding: 5px 10px;
  background-color: #dc3545;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}
button:hover {
  background-color: #c82333;
}
.loading, .error {
  margin: 20px 0;
  padding: 10px;
}
.loading {
  color: #007bff;
}
.error {
  color: #dc3545;
  background-color: #f8d7da;
}
.note {
  margin-top: 20px;
  padding: 10px;
  background-color: #e2e3e5;
  font-size: 0.9em;
}
</style>
EOF
  
  cat > frontend/src/views/UserForm.vue << 'EOF'
<template>
  <div>
    <h2>사용자 등록</h2>
    <div v-if="loading" class="loading">로딩 중...</div>
    <div v-if="error" class="error">{{ error }}</div>
    <form v-else @submit.prevent="handleSubmit">
      <div class="form-group">
        <label for="username">Username:</label>
        <input 
          id="username" 
          v-model="form.username" 
          required
          minlength="3"
          maxlength="50"
        />
      </div>
      <div class="form-group">
        <label for="email">Email:</label>
        <input 
          id="email" 
          v-model="form.email" 
          type="email"
          required
          minlength="5"
          maxlength="100"
        />
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input 
          id="password" 
          v-model="form.password" 
          type="password"
          required
          minlength="6"
          maxlength="255"
        />
      </div>
      <div class="form-group">
        <label for="role">Role:</label>
        <select id="role" v-model="form.role">
          <option value="USER">USER</option>
          <option value="ADMIN">ADMIN</option>
          <option value="MODERATOR">MODERATOR</option>
        </select>
      </div>
      <button type="submit" :disabled="loading">등록</button>
      <button type="button" @click="resetForm" :disabled="loading">취소</button>
      <p class="note">동시성 제어: 동시 접속 시 데이터 충돌 방지</p>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { userApi } from '../api/userApi'

const form = ref({
  username: '',
  email: '',
  password: '',
  role: 'USER'
})
const loading = ref(false)
const error = ref(null)

const handleSubmit = async () => {
  try {
    loading.value = true
    await userApi.createUser(form.value)
    alert('사용자가 등록되었습니다')
    resetForm()
  } catch (err) {
    error.value = '등록에 실패했습니다'
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  form.value = {
    username: '',
    email: '',
    password: '',
    role: 'USER'
  }
  error.value = null
}
</script>

<style scoped>
.form-group {
  margin-bottom: 15px;
}
label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}
input, select {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}
button {
  padding: 10px 15px;
  margin-right: 10px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}
button:hover {
  background-color: #0056b3;
}
button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}
.loading, .error {
  margin: 20px 0;
  padding: 10px;
}
.loading {
  color: #007bff;
}
.error {
  color: #dc3545;
  background-color: #f8d7da;
}
.note {
  margin-top: 20px;
  padding: 10px;
  background-color: #e2e3e5;
  font-size: 0.9em;
}
</style>
EOF
  
  # CRUD 컴포넌트 확인
  find frontend/src -name "*.vue" -type f
  ```

#### Step 5.5: Vite 설정 및 실행
- **학습 내용**: Vite 구성, 개발 서버 실행
- **확인 방법**: 개발 서버 실행 확인
- **명령**:
  ```bash
  cat > frontend/vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
EOF
  
  # Vite 설정 확인
  cat frontend/vite.config.js
  ```

---

### Phase 6: 통합 및 테스트
**목표**: 전체 시스템 검증
**⏱️ 예상 시간**: 30분

#### Step 6.1: 통합 테스트 수행 (동시성 제어 테스트 포함)
- **학습 내용**: End-to-End 테스트, Integration Test, API 테스트, 동시성 제어 테스트
- **확인 방법**: 테스트 실행 결과 로그, 동시성 제어 동작 확인
- **명령**:
  ```bash
  # Spring Boot 애플리케이션 시작
  docker-compose up -d backend oracle-db
  
  # 애플리케이션 시작 대기
  echo "Waiting for Spring Boot to start..."
  sleep 30
  
  # Spring Boot 로그 확인
  docker logs spring-backend --tail 50
  
  # 스키마 적용
  docker exec oracle-db sqlplus system/oracle@localhost:1521/learning_db @/opt/oracle/scripts/sql/schema.sql
  
  # API 엔드포인트 접속 테스트
  echo "=== API 테스트 시작 ==="
  curl -X GET http://localhost:8080/api/users -v
  
  # 동시성 제어 테스트: 2개의 터미널에서 동시 요청
  echo "=== 동시성 제어 테스트 (동시 접속 시뮬레이션) ==="
  echo "터미널 1에서 요청:"
  curl -X POST http://localhost:8080/api/users \
    -H "Content-Type: application/json" \
    -d '{"username":"user1","email":"user1@test.com","password":"password123","role":"USER"}' &
  
  echo "터미널 2에서 요청:"
  curl -X POST http://localhost:8080/api/users \
    -H "Content-Type: application/json" \
    -d '{"username":"user2","email":"user2@test.com","password":"password123","role":"USER"}' &
  
  wait
  
  # Oracle DB 접속 테스트
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 0
  SELECT * FROM user_tables;
  EXIT;
  EOF
  
  # Partition by 테스트
  docker exec oracle-db sqlplus -s system/oracle@localhost:1521/learning_db << 'EOF'
  SET PAGESIZE 100
  SELECT partition_name, high_value 
  FROM user_tab_partitions 
  WHERE table_name = 'USER_ACTIVITY_LOGS';
  EXIT;
  EOF
  ```

#### Step 6.2: 브라우저에서 동작 확인
- **확인 방법**: 브라우저에서 CRUD 기능 동작
- **명령**:
  ```bash
  # Vue.js 개발 서버 시작
  docker-compose up -d frontend
  
  echo "Frontend is running at http://localhost:5173"
  echo "Backend API is running at http://localhost:8080"
  echo "Oracle DB is running at localhost:1521"
  
  # 브라우저에서 확인
  echo "Please open http://localhost:5173 in your browser"
  echo ""
  echo "=== 주요 기능 ==="
  echo "1. 사용자 목록 조회: http://localhost:8080/api/users"
  echo "2. 사용자 등록: POST http://localhost:8080/api/users"
  echo "3. 사용자 조회: GET http://localhost:8080/api/users/{id}"
  echo "4. 사용자 수정: PUT http://localhost:8080/api/users/{id}"
  echo "5. 동시성 제어: http://localhost:8080/api/users/{id}/lock"
  echo "6. 다중 조인: http://localhost:8080/api/users/{id}/with-roles"
  echo ""
  echo "=== 동시성 제어 개념 ==="
  echo "- Optimistic Locking: @Version 애노테이션"
  echo "- Transaction Isolation: SERIALIZABLE 레벨"
  echo "- Query Locking: FOR UPDATE 사용"
  echo "- Oracle Partition by: 데이터 분할 및 성능 최적화"
  echo "- 다중 조인: 테이블 간 관계 매핑"
  ```

---

## 📊 학습 진행 추적

각 단계 완료 시 `.sisyphus/evidence/[Phase]/step[XX]/` 폴더에 증거를 저장하여 진행 상황을 확인합니다.

### 증거 파일 구조
```
.sisyphus/
├── evidence/
│   ├── phase1/
│   │   ├── step1.1/architecture-diagram.md
│   │   └── step1.2/tech-stack-roles.md
│   ├── phase2/
│   │   ├── step2.1/node-version.txt
│   │   ├── step2.2/java-version.txt
│   │   └── step2.3/docker-verify.txt
│   ├── phase3/
│   │   ├── step3.1/pom.xml
│   │   ├── step3.2/application.properties
│   │   └── ...
│   └── phase4/
│       ├── step4.1/schema.sql
│       └── ...
├── plans/
│   └── curriculum.md
└── learning_state.json