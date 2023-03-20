function loadYamlFile(filename) {
  const fs = require("fs");
  const yaml = require("js-yaml");
  const yamlText = fs.readFileSync(filename, "utf8");
  return yaml.load(yamlText);
}

function writeYamlFile(filename, data) {
  const fs = require("fs");
  const yaml = require("js-yaml");
  const yamlText = yaml.dump(data);
  fs.writeFile(filename, yamlText, "utf8", (err) => {
    if (err) {
      console.error(err.message);
      process.exit(1);
    }
    console.log(`{filename} saved`);
  });
}

if (require.main === module) {
  const path = require("path");

  try {
    const filelist = [
      "../src/build_dc/gblan-nginx/docker-compose.yml",
      "../src/build_dc/gblan-share/docker-compose.yml",
      "../src/build_dc/gblan-dns/docker-compose.yml",
      //"../src/build_dc/gblan-sshd/docker-compose.yml",
      //"../src/build_dc/gblan-gitbucket/docker-compose.yml",
      "../src/build_dc/gblan-mkcert/docker-compose.yml"
    ];
    let data = {
      name: "gblan-dev",
      services: {},
      networks: {},
      volumes: {},
    };
    filelist.forEach((filepath) => {
      const data_yaml = loadYamlFile(path.join(__dirname, filepath));
      for (key in data_yaml.services) {
        if (data.services[key]) {
          console.log(`already exists:{data.services[key]}`);
        } else {
          let v = data_yaml.services[key];
          data.services[key] = v;
        }
      }
      for (key in data_yaml.networks) {
        if (data.networks[key]) {
          console.log(`already exists:{data.networks[key]}`);
        } else {
          let v = data_yaml.networks[key];
          data.networks[key] = v;
        }
      }
      for (key in data_yaml.volumes) {
        if (data.volumes[key]) {
          console.log(`already exists:{data.volumes[key]}`);
        } else {
          let v = data_yaml.volumes[key];
          data.volumes[key] = v;
        }
      }
    });
    console.log(data);
    writeYamlFile("../src/docker-compose.yml", data);
  } catch (err) {
    console.error(err.message);
  }
}
