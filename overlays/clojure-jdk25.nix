final: prev: {
  clojure = prev.clojure.override {
    jdk = final.jdk25_headless;
  };

  babashka = prev.babashka.override {
    jdkBabashka = final.jdk25_headless;

    clojureToolsBabashka = prev.babashka.passthru.clojure-tools.override {
      inherit (final) clojure;
    };
  };

  neil = prev.neil.override {
    inherit (final) babashka;
  };
}
