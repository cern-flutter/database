--
-- Copyright (c) CERN 2016
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

--
-- X509 credentials
--

CREATE TABLE t_x509_requests (
    delegation_id CHAR(16) NOT NULL,
    user_dn       VARCHAR(255) NOT NULL,
    request       TEXT NOT NULL,
    private_key   TEXT NOT NULL,
    voms_attrs    TEXT NOT NULL,
    PRIMARY KEY(delegation_id, user_dn)
);

CREATE TABLE t_x509_proxies (
    delegation_id    CHAR(16) NOT NULL,
    user_dn          VARCHAR(255) NOT NULL,
    termination_time TIMESTAMP WITHOUT TIME ZONE,
    voms_attrs       TEXT NOT NULL,
    proxy            TEXT NOT NULL,
    PRIMARY KEY(delegation_id, user_dn)
);

--
-- Static authorization
--
CREATE TABLE t_authz_dn (
    user_dn     VARCHAR(255) NOT NULL,
    operation   VARCHAR(64) NOT NULL,
    PRIMARY KEY(user_dn, operation)
);

--
-- Banned DNs
--
CREATE TABLE t_bad_dns (
    user_dn     VARCHAR(255) NOT NULL PRIMARY KEY,
    message     VARCHAR(255),
    addition_time TIMESTAMP WITHOUT TIME ZONE,
    admin_dn    VARCHAR(255),
    status      CHAR(10),
    wait_timeout INTEGER DEFAULT 0
);

--
-- Jobs
--
CREATE TABLE t_job(
    job_id          CHAR(36) NOT NULL PRIMARY KEY,
    source_se       VARCHAR(255),
    dest_se         VARCHAR(255),
    job_state       CHAR(16),
    submit_host     VARCHAR(255),
    user_dn         VARCHAR(255),
    cred_id         CHAR(16) NOT NULL,
    vo_name         VARCHAR(50) NOT NULL,
    submit_time     TIMESTAMP WITHOUT TIME ZONE,
    finish_time     TIMESTAMP WITHOUT TIME ZONE,
    priority        INTEGER,
    expiration_time TIMESTAMP WITHOUT TIME ZONE,
    space_token     VARCHAR(255),
    overwrite_flag  BOOLEAN,
    source_space_token  VARCHAR(255),
    copy_pin_lifetime   INTEGER,
    bring_online        INTEGER,
    verify_checksum     CHAR(6),
    retry               INTEGER,
    retry_delay         INTEGER,
    reason              VARCHAR(2048),
    job_metadata        JSONB
);

--
-- Transfers
--
CREATE TABLE t_file (
    job_id          CHAR(36) NOT NULL REFERENCES t_job(job_id),
    file_id         CHAR(36) NOT NULL PRIMARY KEY,
    file_index      INTEGER,
    source_se       VARCHAR(255),
    dest_se         VARCHAR(255),
    file_state      CHAR(16),
    transferhost    VARCHAR(255),
    source_surl     VARCHAR(1100),
    dest_surl       VARCHAR(1100),
    reason          VARCHAR(2048),
    recoverable     BOOLEAN,
    filesize        BIGINT,
    checksum        VARCHAR(100),
    finish_time     TIMESTAMP WITHOUT TIME ZONE,
    start_time      TIMESTAMP WITHOUT TIME ZONE,
    pid             INTEGER,
    tx_duration     INTEGER,
    throughput      FLOAT,
    retry           INTEGER,
    user_filesize   BIGINT,
    staging_start   TIMESTAMP WITHOUT TIME ZONE,
    staging_finished    TIMESTAMP WITHOUT TIME ZONE,
    bringonline_token   VARCHAR(255),
    log_file        VARCHAR(2048),
    activity        VARCHAR(255),
    wait_timestamp  TIMESTAMP WITHOUT TIME ZONE,
    wait_timeout    INTEGER,
    file_metadata   JSONB
);

--
-- Database schema versioning
--
CREATE TABLE t_schema_version (
    major INT NOT NULL,
    minor INT NOT NULL,
    patch INT NOT NULL,
    message TEXT,
    PRIMARY KEY (major, minor, patch)
);

INSERT INTO t_schema_version (major, minor, patch, message) VALUES
    (0, 0, 0, 'Experimental');
